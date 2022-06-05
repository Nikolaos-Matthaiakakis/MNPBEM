function [ faces, ind4 ] = totriangles_curv( obj, ind )
%  TOTRIANGLES_CURV - Split quadrilateral face elements to triangles.
%
%  Usage for obj = particle :
%    [ faces, ind4 ] = totriangles_curv( obj )
%    [ faces, ind4 ] = totriangles_curv( obj, ind )
%  Input
%    ind    :  face index
%  Output
%    faces  :  faces of discretized boundary
%    ind4   :  pointer to split quadrilaterals

if ~exist( 'ind', 'var' ),  ind = 1 : size( obj.faces, 1 );  end
%  pointers to triangular and quadrilateral boundary elements
[ ind3, ind4 ] = index34( obj, ind );
%  allocate arrays
faces = zeros( numel( ind ), 6 );

%  triangular boundary elements
if ~isempty( ind3 )
  faces( ind3, : ) = obj.faces2( ind( ind3 ), [ 1, 2, 3, 5, 6, 7 ] );
end
%  quadrilateral boundary elements
if ~isempty( ind4 )
  %  first triangle
  faces( ind4, : ) = obj.faces2( ind( ind4 ), [ 1, 2, 3, 5, 6, 9 ] );
  %  second triangle
  faces = [ faces; obj.faces2( ind( ind4 ), [ 3, 4, 1, 7, 8, 9 ] ) ];
  %  update index
  ind4 = [ ind4, numel( ind ) + transpose( 1 : numel( ind4 ) ) ];
end
