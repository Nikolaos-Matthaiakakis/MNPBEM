function [ faces, ind4 ] = totriangles_flat( obj, ind )
%  TOTRIANGLES_FLAT - Split quadrilateral face elements to triangles.
%
%  Usage for obj = particle :
%    [ faces, ind4 ] = totriangles_flat( obj )
%    [ faces, ind4 ] = totriangles_flat( obj, ind )
%  Input
%    ind    :  face index
%  Output
%    faces  :  faces of discretized boundary
%    ind4   :  pointer to split quadrilaterals

if ~exist( 'ind', 'var' ),  ind = 1 : size( obj.faces, 1 );  end
%  pointers to triangular and quadrilateral boundary elements
[ ~, ind4 ] = index34( obj, ind );
%  faces
faces = obj.faces( ind, [ 1, 2, 3 ] );

if ~isempty( ind4 )
  %  split quadrilateral elements
  faces = [ faces; obj.faces( ind( ind4 ), [ 3, 4, 1 ] ) ];
  %  update index
  ind4 = [ ind4, numel( ind ) + transpose( 1 : numel( ind4 ) ) ];
end
