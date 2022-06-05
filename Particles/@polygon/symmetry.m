function [ obj, full ] = symmetry( obj, sym )
%  Transform polygon for given symmetry.
%    Only the irreducible part of the polygon is kept.
%
%  Usage for obj = polygon :
%    [ obj, full ] = symmetry( oby, sym )
%  Input
%    sym    :  symmetry keyword [], 'x', 'y', or 'xy'
%  Output
%    obj    :  irreducibele part of polygon
%    full   :  symmetrized polygon

full = obj;  
%  do nothing in case of no symmetry
if isempty( sym ),  return;  end

%  handle polygon array
if length( obj ) ~= 1 
  for i = 1 : length( obj )
    [ obj( i ), full( i ) ] = symmetry( obj( i ), sym );
  end
  return
end

%  reduce positions to symmetry
issame = @( a, b ) ( all( abs( a - b ) < 1e-8 ) );
%  close polygon
pos = [ obj.pos; obj.pos( 1, : ) ];
%  round positions
pos( abs( pos( :, 1 ) ) < 1e-8, 1 ) = 0;
pos( abs( pos( :, 2 ) ) < 1e-8, 2 ) = 0;  
%  find positions inside symmetry region
in = inside( pos, sym );
first = find( in, 1, 'first' );
  
if first == 1
  sympos = pos( first, : );
else
  sympos = intersect( pos( first - 1, : ), pos( first, : ), sym );
end
  
for i = first + 1 : size( pos, 1 ); 
  if in( i - 1 ) && in( i )
    sympos = [ sympos; pos( i, : ) ];
  elseif in( i - 1 ) ~= in( i )
    posi = intersect( pos( i - 1, : ), pos( i, : ), sym );
    if ~issame( posi, sympos( end, : ) )
      sympos = [ sympos; posi ];
    end
    if strcmp( sym, 'xy' ) && ~in( i ),  sympos = [ sympos; 0, 0 ];  end    
    if in( i ) && ~issame( posi, pos( i, : ) )
      sympos = [ sympos; pos( i, : ) ];
    end        
  end
end

%  make sure that initial and final position differ
if issame( sympos( 1, : ), sympos( end, : ) )
  sympos = sympos( 1 : end - 1, : );
end
%  set positions and symmetry keyword
[ obj.pos, obj.sym ] = deal( sympos, sym );
%  sort polygon
obj = sort( obj );

%  remove origin for xy-symmetry when polygon crosses only x- or y-axis
if strcmp( sym, 'xy' ) && all( obj.pos( end, : ) == 0 )
  if ~all( any( obj.pos( 1 : end - 1, : ) == 0, 1 ) )
    obj.pos = obj.pos( 1 : end - 1, : );
  end
end

if nargout == 2
  %  symmetrized polygon
  full = obj;  full.sym = [];
  %  remove origin from position list
  if strcmp( sym, 'xy' ) && all( full.pos( end, : ) == 0 )
    full.pos = full.pos( 1 : end - 1, : );
  end
  
  %  flip polygon along x-axis
  if any( strcmp( sym, { 'x', 'xy' } ) ) && any( full.pos( :, 1 ) == 0 )
    full.pos = [ full.pos;  ...
      flipud( bsxfun( @times, full.pos( 2 : end - 1, : ), [ - 1, 1 ] ) ) ];
  end
  %  flip polygon along y-axis
  if any( strcmp( sym, { 'y', 'xy' } ) ) && any( full.pos( :, 2 ) == 0 )
    full.pos = [ full.pos;  ...
      flipud( bsxfun( @times, full.pos( 2 : end - 1, : ), [ 1, - 1 ] ) ) ];
  end
  
end


function in = inside( pos, sym )
%  INSIDE - Determine whether inside symmetry region.

switch sym
  case 'x' 
    in = ( pos( :, 1 ) >= 0 );
  case 'y'
    in = ( pos( :, 2 ) >= 0 ); 
  case 'xy'
    in = ( pos( :, 1 ) >= 0 ) & ( pos( :, 2 ) >= 0 );
end

function pos = intersect( posa, posb, sym )
%  INTERSECT - Intersect connection between polygon points.

xa = posa( 1 );  ya = posa( 2 );
xb = posb( 1 );  yb = posb( 2 );

switch sym
  case 'x'
    pos( 1 ) = 0;
    pos( 2 ) = ya - xa * ( yb - ya ) / ( xb - xa );
  case 'y'
    pos( 1 ) = xa - ya * ( xb - xa ) / ( yb - ya );
    pos( 2 ) = 0;
  case 'xy'
    if xa * xb <= 0
      pos = intersect( posa, posb, 'x' );
    elseif ya * yb <= 0
      pos = intersect( posa, posb, 'y' );
    end
end
