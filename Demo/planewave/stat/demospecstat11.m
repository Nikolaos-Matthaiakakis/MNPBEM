%  DEMOSPECSTAT11 - Field enhancement for metallic sphere above substrate.
%    We consider a metallic nanosphere with a diameter of 4 nm located 1 nm
%    above a substrate and an incoming plane wave, with TM polarization and
%    an excitation angle of 40 degrees.  This program first computes within
%    the quasistatic approximation the surface charge at the resonance
%    wavelength of 520 nm, and then the emission pattern and the electric
%    fields above and within the substrate.
%
%  Runtime on my computer:  4 sec.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 4 ) };
%  location of interface of substrate
ztab = 0;

%  default options for layer structure
op = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, op );
%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' , 'layer', layer );

%  initialize nanosphere
p = trisphere( 144, 4 );
%  layer tolerance 5e-2
p = shift( p, [ 0, 0, - min( p.pos( :, 3 ) ) + 1 + ztab ] ); 

%  set up COMPARTICLE objec
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%  light propagation angle
theta = pi / 180 * reshape( 40, [], 1 );
%  TM mode, excitation from above
dir = [ sin( theta ), 0 * theta, - cos( theta ) ];
pol = [ cos( theta ), 0 * theta,   sin( theta ) ];

%%  BEM simulation                         
%  set up BEM solver
bem = bemsolver( p, op );
%  plane wave excitation
exc = planewave( pol, dir, op );
%  light wavelength in vacuum
enei = 520;
%  surface charge
sig = bem \ exc( p, enei );

%%  emission pattern
%  angles
theta = reshape( linspace( 0, 2 * pi, 301 ), [], 1 );
%  directions for emission
dir = [ cos( theta ), 0 * theta, sin( theta ) ];
%  set up spectrum object
spec = spectrum( dir, op );

%  farfield radiation
f = farfield( spec, sig );
%  norm of Poynting vector
s = vecnorm( cross( f.e, f.h, 2 ) );

%%  computation of electric field
%  mesh for calculation of electric field
%    we add to the grid z-values a small quantity to push points at the
%    interface into the lower substrate
[ x, z ] = meshgrid( linspace( - 6, 6, 61 ), linspace( - 6, 10, 81 ) - 1e-3 );
%  object for electric field
%    MINDIST controls the minimal distance of the field points to the
%    particle boundary, through NMAX it is possible to compute the electric
%    fields in portions and to work with less computer memory
emesh = meshfield( p, x, 0, z, op, 'mindist', 0.12, 'nmax', 2000 );
%  induced and incoming electric field
e = emesh( sig ) + emesh( exc.field( emesh.pt, enei ) );
%  norm of electric field
ee = sqrt( dot( e, e, 3 ) );

%%  final plot
%  plot electric field
imagesc( x( : ), z( : ), ee );  hold on;
plot( [ min( x( : ) ), max( x( : ) ) ], [ 0, 0 ], 'w--' );

%  Cartesian coordinates of Poynting vector
[ sx, sy ] = pol2cart( theta, 5 * s / max( s ) );
%  overlay with Poynting vector
plot( sx, sy, 'w-', 'LineWidth', 1 );

colorbar;  colormap hot( 255 );

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );

title( 'Electric field, radiation pattern' );

set( gca, 'YDir', 'norm' );
axis equal tight
