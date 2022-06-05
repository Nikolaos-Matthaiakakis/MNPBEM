function obj = norm_curv( obj )
%  NORM_CURV - Auxiliary information for discretized particle surface.
%    Compute centroids, areas, and basis vectors for surface elements.
%
%  Usage for obj = particle :
%    obj = norm_curv( obj )

%  number of face elememts
n = size( obj.faces, 1 );
%  integration weights in boundary elements
[ ~, w ] = quad( obj );
%  area of boundary elements
obj.area = full( sum( w, 2 ) );

%  index to triangular and quadrilateral boundary elements
[ ind3, ind4 ] = index34( obj );
%  split quadrilateral face elements to triangles 
faces = totriangles( obj );

%  allocate arrays for centroids and derivative vectors
[ pos, vec1, vec2 ] = deal( zeros( n, 3 ), zeros( n, 3 ), zeros( n, 3 ) );

%  triangular elememts
if ~isempty( ind3 )
  %  shape elements and derivatives at center
  tri  = [ - 1, - 1, - 1, 4,   4,   4 ] / 9;
  trix = [   1,   0, - 1, 4, - 4,   0 ] / 3;
  triy = [   0,   1, - 1, 4,   0, - 4 ] / 3;
  %  loop over face elements
  for i = 1 : 6
    %  centroid
    pos( ind3, : ) = pos( ind3, : ) + tri( i ) * obj.verts2( faces( ind3, i ), : );
    %  derivative vectors
    vec1( ind3, : ) =  vec1( ind3, : ) + triy( i ) * obj.verts2( faces( ind3, i ), : );
    vec2( ind3, : ) =  vec2( ind3, : ) + trix( i ) * obj.verts2( faces( ind3, i ), : );
  end
end

%  quadrilateral elements
if ~isempty( ind4 )
  %  last midpoint of triangle is centroid of quadrilateral
  pos( ind4, : ) = obj.verts2( faces( ind4, 6 ), : );
  %  derivatives of shape element
  trix = [ 1,   0, - 1, 0, 0    0 ];
  triy = [ 0, - 1, - 1, 2  2, - 2 ];
  for i = 1 : 6
    %  derivative vectors
    vec1( ind4, : ) =  vec1( ind4, : ) + triy( i ) * obj.verts2( faces( ind4, i ), : );
    vec2( ind4, : ) =  vec2( ind4, : ) + trix( i ) * obj.verts2( faces( ind4, i ), : );
  end  
end

%  normalization
normalize = @( x ) bsxfun( @rdivide, x, sqrt( dot( x, x, 2 ) ) );
%  normal and tangential vector
nvec = normalize( cross( vec1, vec2, 2 ) );
vec1 = normalize( vec1 );
%  make orthonormal basis
vec2 = cross( nvec, vec1, 2 );

%  save centroids and orthonormal basis
[ obj.pos, obj.vec ] = deal( pos, { vec1, vec2, nvec } );
