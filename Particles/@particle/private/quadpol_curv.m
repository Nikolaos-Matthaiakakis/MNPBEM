function [ pos, weight, row ] = quadpol_curv( obj, ind )
%  QUADPOL - Quadrature points and weights for boundary element
%            integration in polar coordinates.
%
%  Usage for obj = particlecurv :
%    [ pos, weight, row ] = quadpol( obj, ind )
%  Input
%    ind     :  face index or indices
%  Output
%    pos     :  integration points
%    weight  :  integration weights
%    row     :  to perform an integration inside the elements use
%                 accumarray( row, weight .* fun( pos ) )

if ~exist( 'ind', 'var' ),  ind = 1 : size( obj.faces, 1 );  end

%  index to triangular and quadrilateral boundary elements
[ ind3, ind4 ] = index34( obj, ind );
%  decompose into triangles
faces = obj.faces2( ind, : );

%  quadrature rule for polar integration
q = obj.quad;
%  number of integration points in boundary elements
[ m3, m4 ] = deal( numel( q.x3 ), numel( q.x4 ) );
%  total number of integration points
n = numel( ind3 ) * m3 + numel( ind4 ) * m4;
%  allocate arrays for integration points and weights
pos = zeros( n, 3 );
[ weight, row ] = deal( zeros( n, 1 ), zeros( n, 1 ) );
%  offset vector
offset = 0;

%  triangular face elements
if ~isempty( ind3 )
  %  positions and weights for polar integration
  [ x, y, w ] = deal( q.x3, q.y3, q.w3 );
  %  triangular shape function
  s = shape.tri( 6 );
  %  values and derivatives of shape functions
  [ tri, trix, triy ] = deal( s( x, y ), s.x( x, y ), s.y( x, y ) );
  
  %  loop over triangular elements
  for i = reshape( ind3, 1, [] )
    %  index
    it = offset + ( 1 : m3 );  
    %  interpolate integration points
    pos( it, : ) = tri * obj.verts2( faces( i, [ 1, 2, 3, 5, 6, 7 ] ), : );
    %  derivatives with respect to triangular coordinates
    posx = trix * obj.verts2( faces( i, [ 1, 2, 3, 5, 6, 7 ] ), : );
    posy = triy * obj.verts2( faces( i, [ 1, 2, 3, 5, 6, 7 ] ), : );
    %  normal vector
    nvec = cross( posx, posy, 2 ); 
    %  integration weights and indices
    weight( it ) = 0.5 * w .* sqrt( dot( nvec, nvec, 2 ) );
    row( it ) = i;
    %  update offset
    offset = offset + m3;
  end
end

%  quadrilateral face elements
if ~isempty( ind4 )
  %  positions and weights for polar integration
  [ x, y, w ] = deal( q.x4, q.y4, q.w4 );
  %  quadrilateral shape elements
  s = shape.quad( 9 );
  %  values and derivatives of shape functions
  [ quad, quadx, quady ] = deal( s( x, y ), s.x( x, y ), s.y( x, y ) );  
  
  %  loop over quadrilateral elements
  for i = reshape( ind4, 1, [] )
    %  index
    it = offset + ( 1 : m4 );  
    %  interpolate integration points
    pos( it, : ) = quad * obj.verts2( faces( i, 1 : 9 ), : );
    %  derivatives with respect to quadrilateral coordinates
    posx = quadx * obj.verts2( faces( i, 1 : 9 ), : );
    posy = quady * obj.verts2( faces( i, 1 : 9 ), : );
    %  normal vector
    nvec = cross( posx, posy, 2 ); 
    %  integration weights and indices
    weight( it ) = w .* sqrt( dot( nvec, nvec, 2 ) );
    row( it ) = i;
    %  update offset
    offset = offset + m4;
  end
end
