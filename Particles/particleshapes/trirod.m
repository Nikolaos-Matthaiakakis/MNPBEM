function p = trirod( diameter, height, varargin )
%  TRIROD - Faces and vertices for rod-shaped particle.
%
%  Usage :
%    p = trirod( diameter, height,                 varargin )
%    p = trirod( diameter, height, n,              varargin )
%    p = trirod( diameter, height, n, 'triangles', varargin )
%  Input
%    diameter     :  diameter of rod
%    height       :  total height (length) of rod
%    n            :  number of discretization points [ nphi, ntheta, nz ]
%    'triangles'  :  use triangles rather than quadrilaterals
%    varargin     :  additional arguments to be passed to PARTICLE
%  Output
%    p            :  faces and vertices of triangulated rod

%  extract number of discretization points
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ n, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
  assert( numel( n ) == 3 );
else
  n = [ 15, 20, 20 ];
end

%  angles 
phi   = linspace( 0, 2   * pi, n( 1 ) );
theta = linspace( 0, 0.5 * pi, n( 2 ) );
%  z-values of cylinder
z = 0.5 * linspace( - 1, 1, n( 3 ) ) * ( height - diameter );

%  upper cap
cap1 = shift( trispheresegment( phi, theta, diameter, varargin{ : } ),  ...
                              [ 0, 0, 0.5 * ( height - diameter ) ] );
%  lower cap
cap2 = flip( cap1, 3 );

%  grid for cylinder discretization
[ verts, faces ] = fvgrid( phi, z, varargin{ : } );
%  cylinder coordinates
[ phi, z ] = deal( verts( :, 1 ), verts( :, 2 ) );
%  make cylinder
x = 0.5 * diameter * cos( phi );
y = 0.5 * diameter * sin( phi );

%  remove TRIANGLES argument from varargin
if ~isempty( varargin ) && ischar( varargin{ 1 } )  ...
                        && strcmp( varargin{ 1 }, 'triangles' )
  varargin = varargin( 2 : end );
end
%  cylinder particle
cyl = particle( [ x, y, z ], faces, varargin{ : } );

%  compose particle
p = clean( [ cap1; cap2; cyl ] );
