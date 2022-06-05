function  p = trispheresegment( phi, theta, varargin )
%  TRISPHERESEGMENT - Discretized surface of sphere.
%
%  Usage :
%    p = trispheresegment( phi, theta, diameter, varargin )
%    p = trispheresegment( phi, theta, diameter, 'triangles', varargin )
%    
%  Input
%    phi          :  azimuthal angles
%    theta        :  polar angles
%    diameter     :  diameter fo sphere
%    'triangles'  :  use triangles rather than quadrilaterals
%    varargin     :  additional arguments to be passed to PARTICLE
%  Output
%    p            :  discretized particle surface

%  extract diameter
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ diameter, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
else
  diameter = 1;
end
%  extract triangle keyword
if ~isempty( varargin ) && ischar( varargin{ 1 } )  ...
                        && strcmp( varargin{ 1 }, 'triangles' )
  [ triangles, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end

%%  particle surface
%  grid of PHI and THETA values
[ phi, theta ] = meshgrid( phi, theta );

x = diameter / 2 * sin( theta ) .* cos( phi );
y = diameter / 2 * sin( theta ) .* sin( phi );
z = diameter / 2 * cos( theta );

%  triangular faces
if exist( 'triangles', 'var' ) && strcmp( triangles, 'triangles' );
  [ faces, verts ] = surf2patch( x, y, z, 'triangles' );
  p = clean( particle( verts, faces ) );
%  quadrilaterals
else
  [ faces, verts ] = surf2patch( x, y, z );
  p = clean( particle( verts, faces ) );
end

%%  vertices and faces for curved particle boundary
%  add midpoints
p = midpoints( p, 'flat' );
%  rescale vertices
verts2 = 0.5 * diameter *  ...
    bsxfun( @rdivide, p.verts2, sqrt( dot( p.verts2, p.verts2, 2 ) ) );
%  make particle including mid points 
p = particle( verts2, p.faces2, varargin{ : } );
