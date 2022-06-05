function [ verts, faces ] = fvgrid( x, y, triangles, varargin )
%  FVGRID - Convert 2d grid to face-vertex structure.
%
%  Usage :
%    [ verts, faces ] = fvgrid( x, y, triangles )
%  Input
%    x            :  x-coordinates of grid
%    y            :  y-coordinates of grid
%    'triangles'  :  use triangles rather than quadrilaterals
%  Output
%    verts        :  vertices of triangulated grid (to be used in PARTICLE)
%    faces        :  faces of triangulated grid

if min( size( x ) ) == 1, [ x, y ] = meshgrid( x, y );  end

%  make grid
if exist( 'triangles', 'var' ) && strcmp( triangles, 'triangles' )
  [ faces, verts ] = surf2patch( x, y, 0 * x, 'triangles' );
  p = particle( verts, fliplr( faces ), 'norm', 'off' );
else
  [ faces, verts ] = surf2patch( x, y, 0 * x );
  p = particle( verts, fliplr( faces ), 'norm', 'off' );
end  

%  add midpoints
p = midpoints( p, 'flat' );
%  extract faces and vertices
[ verts, faces ] = deal( p.verts2, p.faces2 );
