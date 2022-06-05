function [ net, faces ] = edges( obj )
%  EDGES - Find unique edges of particle.
%
%  Usage for obj = particle :
%    [ net, ind ] = edges( obj )
%  Output
%    net    :  list of unique edges
%    ind    :  index to edge list for triangular and quadrilateral faces

%  faces
faces = obj.faces;
%  index to triangular and quadrilateral boundary elements
[ ind3, ind4 ] = index34( obj );

%  edge list
net = [ faces( ind3, [ 1, 2 ] ); faces( ind3, [ 2, 3 ] );  ...
        faces( ind3, [ 3, 1 ] );                           ...
        faces( ind4, [ 1, 2 ] ); faces( ind4, [ 2, 3 ] );  ...
        faces( ind4, [ 3, 4 ] ); faces( ind4, [ 4, 1 ] ) ];     
%  unique edges
[ net, ~, ind ] = unique( sort( net, 2 ), 'rows' );

%  face list of edges
faces( ind3, 1 : 3 ) = reshape( ind(   1 : 3 * numel( ind3 ) ),         [], 3 );
faces( ind4, 1 : 4 ) = reshape( ind( ( 1 + 3 * numel( ind3 ) ) : end ), [], 4 );
 