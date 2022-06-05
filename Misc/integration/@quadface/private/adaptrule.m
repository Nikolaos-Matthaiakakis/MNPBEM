function [ pos, w ] = adaptrule( obj, verts, tri )
%  ADAPTRULE - Adapt triangle integration.

%  triangle corners
v1 = verts( tri( 1 ), : );  
v2 = verts( tri( 2 ), : );  
v3 = verts( tri( 3 ), : );  

%  linear triangle integration
pos = obj.x( : ) * v1 + obj.y( : ) * v2 + ( 1 - obj.x( : ) - obj.y( : ) ) * v3;
%  normal vector
nvec = cross( v1 - v3, v2 - v3 );
%  integration weight
w = 0.5 * obj.w * sqrt( dot( nvec, nvec ) );
