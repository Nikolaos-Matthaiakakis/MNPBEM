function p = tritorus( diameter, rad, varargin )
%  TRITORUS - Faces and vertices of triangulated torus.
%
%  Usage :
%    p = tritorus( diameter, rad,                 varargin )
%    p = tritorus( diameter, rad, n,              varargin )
%    p = tritorus( diameter, rad, n, 'triangles', varargin )
%  Input
%    diameter     :  diameter of folded cylinder
%    rad          :  radius of torus
%    n            :  number of discretization points
%    'triangles'  :  use triangles rather than quadrilaterals
%    varargin     :  additional arguments to be passed to PARTICLE
%  Output
%    p            :  faces and vertices of triangulated torus

%  extract number of discretization points
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ n, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
  if numel( n ) == 1,  n = [ n, n ];  end
else
  n = [ 21, 21 ];
end
%  extract triangle keyword
if ~isempty( varargin ) && ischar( varargin{ 1 } )  ...
                        && strcmp( varargin{ 1 }, 'triangles' )
  [ triangles, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
else
  triangles = '';
end

%  grid triangulation
[ verts, faces ] = fvgrid( linspace( 0, 2 * pi, n( 1 ) ),  ...
                           linspace( 0, 2 * pi, n( 2 ) ), triangles );
%  angles
[ phi, theta ] = deal( verts( :, 1 ), verts( :, 2 ) );
%  coordinates of torus
x = ( 0.5 * diameter + rad * cos( theta ) ) .* cos( phi );
y = ( 0.5 * diameter + rad * cos( theta ) ) .* sin( phi );
z =                    rad * sin( theta );
% make torus
p = clean( particle( [ x, y, z ], faces, varargin{ : } ) );
