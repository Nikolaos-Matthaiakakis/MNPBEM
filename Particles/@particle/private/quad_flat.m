function [ pos, w, iface ] = quad_flat( obj, ind )
%  QUAD_FLAT - Quadrature points and weights for boundary element integration.
%
%  Usage for obj = particle :
%    [ pos, w, iface ] = quad_flat( obj, ind )
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
%  normal vector of triangular elements
nvec = cross( obj.verts( faces( :, 2 ), : ) - obj.verts( faces( :, 1 ), : ),  ...
              obj.verts( faces( :, 3 ), : ) - obj.verts( faces( :, 1 ), : ), 2 );
%  area of triangular elements
area = 0.5 * sqrt( dot( nvec, nvec, 2 ) );

%  integration points and weights
[ x, y, w ] = deal( obj.quad.x( : ), obj.quad.y( : ), obj.quad.w );
%  number of integration points
m = numel( w );
%  total number of integration points
n = m * numel( ind3 );
%  allocate arrays for integration points and weights
pos = zeros( n, 3 );
[ weight, row, col ] = deal( zeros( n, 1 ), zeros( n, 1 ), zeros( n, 1 ) );
%  offset vector
offset = 0;

%  triangular shape elements
tri = [ x, y, 1 - x - y ];
%  loop over triangular elements
for i = 1 : numel( ind3 )
  %  index
  it = offset + ( 1 : m );  
  %  interpolate integration points
  pos( it, : ) =  tri * obj.verts( faces( i, 1 : 3 ), : );
  %  integration weights
  weight( it ) = w .* area( i );
  [ row( it ), col( it ) ] = deal( ind3( i ), it );  
  %  update offset
  offset = offset + m;
end

%  weight matrix
w = sparse( row, col, weight );
%  face index for integration points
[ ~, ~, iface ] = find( sparse( row, col, row ) );
