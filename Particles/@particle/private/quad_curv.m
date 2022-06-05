function [ pos, w, iface ] = quad_curv( obj, ind )
%  QUAD_CURV - Quadrature points and weights for boundary element integration.
%
%  Usage for obj = particlecurv :
%    [ pos, w, iface ] = quad( obj, ind )
%  Input
%    ind    :  face index or indices
%  Output
%    pos    :  integration points
%    w      :  integration weights
%    iface  :  face index for integration points

if ~exist( 'ind', 'var' ),  ind = 1 : size( obj.faces, 1 );  end

%  decompose into triangles
[ faces, ind4 ] = totriangles( obj, ind );
%  index to triangles
ind3 = 1 : numel( ind );
if ~isempty( ind4 ),  ind3 = [ ind3, ind4( :, 1 )' ];  end

%  integration points and weights
[ x, y, w ] = deal( obj.quad.x( : ), obj.quad.y( : ), obj.quad.w( : ) );
%  number of integration points
m = numel( w );
%  total number of integration points
n = m * numel( ind3 );
%  allocate arrays for integration points and weights
pos = zeros( n, 3 );
[ weight, row, col ] = deal( zeros( n, 1 ), zeros( n, 1 ), zeros( n, 1 ) );
%  offset vector
offset = 0;

%  triangular shape function
s = shape.tri( 6 );
%  values and derivatives of shape functions
[ tri, trix, triy ] = deal( s( x, y ), s.x( x, y ), s.y( x, y ) );

%  loop over triangular elements
for i = 1 : numel( ind3 )
  %  index
  it = offset + ( 1 : m );  
  %  interpolate integration points
  pos( it, : ) =  tri * obj.verts2( faces( i, : ), : );
  %  derivatives with respect to triangular coordinates
  posx = trix * obj.verts2( faces( i, : ), : );
  posy = triy * obj.verts2( faces( i, : ), : );
  %  normal vector
  nvec = cross( posx, posy, 2 );
  %  integration weights
  weight( it ) = 0.5 * w .* sqrt( dot( nvec, nvec, 2 ) );
  [ row( it ), col( it ) ] = deal( ind3( i ), it );
  %  update offset
  offset = offset + m;
end

%  weight matrix
w = sparse( row, col, weight );
%  face index for integration points
[ ~, ~, iface ] = find( sparse( row, col, row ) );
