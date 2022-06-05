function p2 = shift( p1, d, varargin )
%  SHIFT - Shift boundary for creation of cover layer structure.
% 
%  Usage : 
%    p2 = coverlayer.shift( p1, d, op, PropertyPairs )
%    p2 = coverlayer.shift( p1, d,     PropertyPairs )
%  Input
%    p1       :  particle
%    d        :  shift distance 
%  PropertyName
%    'nvec'   :  shift vertices along directions of NVEC
%  Output
%    p2       :  shifted boundary

if numel( d ) == 1,  d = repmat( d, p1.nverts, 1 );  end

%  get options
op = getbemoptions( varargin{ : } );
%  get normal vector
if isfield( op, 'nvec' )
  nvec = op.nvec;
else
  %  interpolate normal vectors from faces to vertices
  nvec = interp( p1, p1.nvec );
end

if isempty( p1.verts2 )
  %  unique vertices
  %    when shifting the vertices, we have to be careful about particle
  %    boundaries with duplicate vertices
  [ ~, i1, i2 ] = unique( misc.round( p1.verts, 4 ), 'rows' );  
  %  particle with shifted vertices
  p2 = particle(  ...
    p1.verts + bsxfun( @times, nvec( i1( i2 ), : ), d ), p1.faces, varargin{ : } );
else
  %  interpolate D and NVEC to midpoints ?
  d = interp2( p1, d );
  if size( nvec, 1 ) ~= size( p1.verts2, 1 ),  nvec = interp2( p1, nvec );  end    
  %  particle with shifted vertices
  p2 = particle( p1.verts2 + bsxfun( @times, nvec, d ), p1.faces2, varargin{ : } );
end


function v2 = interp2( p, v )
%  INTERP2 - Interpolate normal vectors from VERTS to VERTS2.

%  index to triangles and quadrilaterals
[ ind3, ind4 ] = index34( p );
%  allocate output
v2 = zeros( size( p.verts2, 1 ), size( v, 2 ) );

if ~isempty( ind3 )
  %  triangle indices
  i1 = p.faces2( ind3, 1 );  i10 = p.faces( ind3, 1 );
  i2 = p.faces2( ind3, 2 );  i20 = p.faces( ind3, 2 );
  i3 = p.faces2( ind3, 3 );  i30 = p.faces( ind3, 3 );
  i4 = p.faces2( ind3, 5 );
  i5 = p.faces2( ind3, 6 );
  i6 = p.faces2( ind3, 7 );
  %  assign output
  v2( i1, : ) = v( i10, : );
  v2( i2, : ) = v( i20, : );
  v2( i3, : ) = v( i30, : );
  v2( i4, : ) = 0.5 * ( v( i10, : ) + v( i20, : ) );
  v2( i5, : ) = 0.5 * ( v( i20, : ) + v( i30, : ) );
  v2( i6, : ) = 0.5 * ( v( i30, : ) + v( i10, : ) );
end

if ~isempty( ind4 )
  %  quadrilateral indices
  i1 = p.faces2( ind4, 1 );  i10 = p.faces( ind4, 1 );
  i2 = p.faces2( ind4, 2 );  i20 = p.faces( ind4, 2 );
  i3 = p.faces2( ind4, 3 );  i30 = p.faces( ind4, 3 );
  i4 = p.faces2( ind4, 4 );  i40 = p.faces( ind4, 4 );
  i5 = p.faces2( ind4, 5 );
  i6 = p.faces2( ind4, 6 );
  i7 = p.faces2( ind4, 7 );
  i8 = p.faces2( ind4, 8 );
  i9 = p.faces2( ind4, 9 );
  %  assign output
  v2( i1, : ) = v( i10, : );
  v2( i2, : ) = v( i20, : );
  v2( i3, : ) = v( i30, : );
  v2( i4, : ) = v( i40, : );
  v2( i5, : ) = 0.50 * ( v( i10, : ) + v( i20, : ) );
  v2( i6, : ) = 0.50 * ( v( i20, : ) + v( i30, : ) );  
  v2( i7, : ) = 0.50 * ( v( i30, : ) + v( i40, : ) );
  v2( i8, : ) = 0.50 * ( v( i40, : ) + v( i10, : ) );  
  v2( i9, : ) = 0.25 * ( v( i10, : ) + v( i20, : ) +  ...
                         v( i30, : ) + v( i40, : ) );
end

%  unique vertices
[ ~, i1, i2 ] = unique( misc.round( p.verts2, 4 ), 'rows' );
v2 = v2( i1( i2 ), : );
