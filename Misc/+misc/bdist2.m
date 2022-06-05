function d = bdist2( p1, p2 )
%  BDIST2 - Minimal distance between positions P1 and boundary elements P2.
%
%  Usage :
%    d = bdist2( p1, p2 )
%  Input
%    p1     :  positions P1.POS
%    p2     :  discretized particle boundary 
%  Output
%    d      :  minimal distance between P1.POS and boundary elements P2

%  allocate distance array
d = zeros( p1.n, p2.n );
%  triangles and quadrilateral faces
ind3 = find(  isnan( p2.faces( :, 4 ) ) );
ind4 = find( ~isnan( p2.faces( :, 4 ) ) );

%  minimal distance between points and edges of boundary elements
d( :, ind3 ) = PointEdgeDist( p1.pos, p2.verts, p2.faces( ind3, 1 : 3 ) );
d( :, ind4 ) = PointEdgeDist( p1.pos, p2.verts, p2.faces( ind4, 1 : 4 ) );
%  compare with points inside of boundary elements
d( :, ind3 ) = min( d( :, ind3 ),  ...
  PointTriangleDist( p1.pos, p2.verts, p2.faces( ind3, 1 : 3 ) ) );
d( :, ind4 ) = min( min( d( :, ind4 ),  ...
  PointTriangleDist( p1.pos, p2.verts, p2.faces( ind4, [ 1, 2, 3 ] ) ) ),  ...
  PointTriangleDist( p1.pos, p2.verts, p2.faces( ind4, [ 3, 4, 1 ] ) ) );


function d = PointEdgeDist( pos, verts, faces )
%  POINTEDGEDIST - Minimal distance between points and boundary edges.
%
%  The edge boundary is parameterized through
%    g :  r = Q + lambda * a

%  allocate array
d = inf( size( pos, 1 ), size( faces, 1 ) );
if isempty( faces ),  return;  end
%  close faces
faces = [ faces, faces( :, 1 ) ];

%  loop over face boundaries
for i = 2 : size( faces, 2 )
  %  first and second vertex
  v1 = verts( faces( :, i - 1 ), : );
  v2 = verts( faces( :, i     ), : );
  %  difference vector
  a = v2 - v1; 
  %  parameter for minimal distance
  lambda = bsxfun( @rdivide,  ...
    bsxfun( @minus, pos * a', dot( v1, a, 2 )' ), dot( a, a, 2 )' );
  %  0 <= lambda <= 1
  lambda = max( min( lambda, 1 ), 0 ); 
  %  minimum distance between point and line segment
  d = min( d, sqrt( misc.pdist2( pos, v1 ) .^ 2 +      ...
    bsxfun( @times, lambda .^ 2, dot( a, a, 2 )' ) -   ...
    2 * lambda .* bsxfun( @minus, pos * a', dot( v1, a, 2 )' ) ) );
end


function d = PointTriangleDist( pos, verts, faces )
%  POINTTRIANGLEDIST - Normal distance between points and triangle plane.
%    If the crossing point of the triangle plane and the line normal to the
%    plane passing through POS lies outside the triangles, the distance is
%    set to infinity.
%
%  The crossing point between the line and the plane is computed from
%    g :  r = POS + lambda * n
%    e :  r = Q + mu1 * a1 + mu2 * a2

%  allocate array
d = inf( size( pos, 1 ), size( faces, 1 ) );
if isempty( faces ),  return;  end
%  normalize vetor and multiplication
norm = @( x ) bsxfun( @rdivide, x, sqrt( dot( x, x, 2 ) ) );
mul = @( x, y ) bsxfun( @times, x, y );

%  triangle vertices
v1 = verts( faces( :, 1 ), : );
v2 = verts( faces( :, 2 ), : );
v3 = verts( faces( :, 3 ), : );
%  vectors of plane
a1 = v2 - v1; 
a2 = v3 - v1; 
%  inner product of position and plane vectors
in1 = bsxfun( @minus, pos * a1', dot( v1, a1, 2 )' );
in2 = bsxfun( @minus, pos * a2', dot( v1, a2, 2 )' );
%  inner products of plane vectors
a11 = dot( a1, a1, 2 );
a12 = dot( a1, a2, 2 );
a22 = dot( a2, a2, 2 );
%  determinant
det = a11 .* a22 - a12 .^ 2;
%  crossing point
mu1 = bsxfun( @rdivide, mul( in1, a22' ) - mul( in2, a12' ), det' );
mu2 = bsxfun( @rdivide, mul( in2, a11' ) - mul( in1, a12' ), det' );
%  find elements inside of triangles
in = ( mu1 >= 0 ) & ( mu1 <= 1 ) &  ...
     ( mu2 >= 0 ) & ( mu2 <= 1 ) & ( mu1 + mu2 <= 1 );
   
%  normal vector of plane
nvec = norm( cross( a1, a2, 2 ) ); 
%  minimal distance between triangle planes and points
d = abs( bsxfun( @minus, pos * nvec', dot( v1, nvec, 2 )' ) );
%  set D to infinity if crossing point lies outside of triangle
d( ~in ) = Inf;
