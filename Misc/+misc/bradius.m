function r = bradius( p )
%  BRADIUS - Minimal radius for spheres enclosing boundary elements.
%
%  Usage :
%    r = bradius( p )
%  Input
%    p      :  discretized particle boundary
%  Output
%    r      :  minimal radius for spheres enclosing boundary elements

%  allocate array
r = zeros( p.n, 1 );
%  triangles and quadrilateral faces
ind3 = find(  isnan( p.faces( :, 4 ) ) );
ind4 = find( ~isnan( p.faces( :, 4 ) ) );
%  distance between points X and Y
dist = @( x, y ) sqrt( sum( ( x - y ) .^ 2, 2 ) );

%  maximal distance between centroids and triangle edges
if ~isempty( ind3 )
  for i = 1 : 3
    r( ind3 ) = max( r( ind3 ),  ...
      dist( p.pos( ind3, : ), p.verts( p.faces( ind3, i ), : ) ) );
  end
end
%  maximal distance between centroids and quadface edges
if ~isempty( ind4 )
  for i = 1 : 4
    r( ind4 ) = max( r( ind4 ),  ...
      dist( p.pos( ind4, : ), p.verts( p.faces( ind4, i ), : ) ) );
  end
end
