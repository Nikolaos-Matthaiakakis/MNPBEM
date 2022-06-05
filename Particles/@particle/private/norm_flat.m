function obj = norm_flat( obj )
%  NORM_FLAT - Auxiliary information for discretized particle surface.
%    Compute centroids, areas, and basis vectors for surface elements.
%
%  Usage for obj = particle :
%    obj = norm_flat( obj )

%  number of face elememts
n = size( obj.faces, 1 );
%  index to triangular and quadrilateral face elements
[ ind3, ind4 ] = index34( obj );

%  allocate array
obj.pos = zeros( n, 3 );
%  centroid positions of triangular elements
if ~isempty( ind3 )
  obj.pos( ind3, : ) = ( obj.verts( obj.faces( ind3, 1 ), : ) +  ...
                         obj.verts( obj.faces( ind3, 2 ), : ) +  ...
                         obj.verts( obj.faces( ind3, 3 ), : ) ) / 3;
end
%  centroid positions of quadrilateral elements
if ~isempty( ind4 )
  obj.pos( ind4, : ) = ( obj.verts( obj.faces( ind4, 1 ), : ) +  ...
                         obj.verts( obj.faces( ind4, 2 ), : ) +  ...
                         obj.verts( obj.faces( ind4, 3 ), : ) +  ...                       
                         obj.verts( obj.faces( ind4, 4 ), : ) ) / 4;
end

%  split face elements into triangles
[ faces, ind4 ] = totriangles( obj );
%  vertices
v1 = obj.verts( faces( :, 1 ), : );
v2 = obj.verts( faces( :, 2 ), : );
v3 = obj.verts( faces( :, 3 ), : );
%  triangle vectors
[ vec1, vec2 ] = deal( v1 - v2, v3 - v2 );
%  normal vector
nvec = cross( vec1, vec2, 2 );

%  area of triangular elements
area = 0.5 * sqrt( dot( nvec, nvec, 2 ) );
%  normalize vectors
vec1 = bsxfun( @rdivide, vec1, sqrt( dot( vec1, vec1, 2 ) ) );
nvec = bsxfun( @rdivide, nvec, sqrt( dot( nvec, nvec, 2 ) ) );
%  make orthogonal basis
vec2 = cross( nvec, vec1 );

if isempty( ind4 )
  %  quadrilateral elements
  [ obj.area, obj.vec ] = deal( area, { vec1, vec2, nvec } );
else
  %  accumulate area
  obj.area = accumarray( [ transpose( 1 : n ); ind4( :, 1 ) ], area );
  %  index to larger areas
  [ ~, ind ] = max( [ area( ind4( :, 1 ) ), area( ind4( :, 2 ) ) ], [], 2 );
  %  select vectors from larger elements
  vec1( ind4( ind == 2, 1 ), : ) = vec1( ind4( ind == 2, 2 ), : );
  vec2( ind4( ind == 2, 1 ), : ) = vec2( ind4( ind == 2, 2 ), : );
  nvec( ind4( ind == 2, 1 ), : ) = nvec( ind4( ind == 2, 2 ), : );
  %  save basis
  obj.vec = { vec1( 1 : n, : ), vec2( 1 : n, : ), nvec( 1 : n, : ) };
end
