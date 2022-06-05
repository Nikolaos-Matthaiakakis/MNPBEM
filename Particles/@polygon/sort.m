function obj = sort( obj )
%  Normal order of polygons for internal use.
%    In case of symmetry the origin or a point on the x/y-axis becomes the 
%    first one in the list.
%
%  Usage for obj = polygon :
%    obj = sort( obj )

if length( obj ) ~= 1
  for i = 1 : length( obj )
    obj( i ) = sort( obj( i ) ); 
  end
  return
end

%  check for symmetry
if isempty( obj.sym );  return;  end

%  find positions that lie on x and/or y axis
ind = [];

if any( strcmp( obj.sym, { 'x', 'xy' } ) )
  ind = find( abs( obj.pos( :, 1 ) < 1e-6 ) );
end
if any( strcmp( obj.sym, { 'y', 'xy' } ) )
  ind = unique( [ ind; find( abs( obj.pos( :, 2 ) ) < 1e-6 ) ] );
end

%  shift positions such that first/last point are on x/y axis
if length( ind ) >= 2 && ind( 1 ) ~= 1 
  obj.pos = circshift( obj.pos, [ size( obj.pos, 1 ) - ind( end ) + 1, 0 ] ); 
end
