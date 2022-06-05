%  DEMODIPSTAT6 - Electric field for dipole between sphere and layer.
%    For a metallic nanosphere with a diameter of 4 nm located 1 nm above a
%    substrate and a dipole located between sphere and layer, this program
%    computes the radiation pattern and the total electric field using the
%    quasistatic approximation.
%
%  Runtime on my computer:  22 sec.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 2.25 ) }; 
%  location of interface of substrate
ztab = 0;

%  default options for layer structure
opt = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, opt );
%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' , 'layer', layer );

%  nanosphere with finer discretization at the bottom
p = flip( trispheresegment( 2 * pi * linspace( 0, 1, 31 ),  ...
                                pi * linspace( 0, 1, 31 ) .^ 2, 4 ), 3 );
%  place nanosphere 1 nm above substrate
p = shift( p, [ 0, 0, - min( p.pos( :, 3 ) ) + 1 + ztab ] ); 

%  set up COMPARTICLE object
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%%  dipole oscillator
enei = 550;
%  compoint
pt = compoint( p, [ 1, 0, 0.5 ], op );
%  dipole excitation
dip = dipole( pt, [ 0, 0, 1 ], op );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );
%  surface charge
sig = bem \ dip( p, enei );

%%  emission pattern
%  angles
theta = reshape( linspace( 0, 2 * pi, 301 ), [], 1 );
%  directions for emission
dir = [ cos( theta ), 0 * theta, sin( theta ) ];
%  set up spectrum object
spec = spectrum( dir, op );

%  farfield radiation
f = farfield( spec, sig ) + farfield( dip, spec, enei );
%  norm of Poynting vector
s = vecnorm( 0.5 * real( cross( f.e, conj( f.h ), 2 ) ) );

%%  computation of electric field
%  mesh for calculation of electric field
[ x, z ] = meshgrid( linspace( - 8, 8, 81 ) );
%  object for electric field
%    MINDIST controls the minimal distance of the field points to the
%    particle boundary
emesh = meshfield( p, x, 0, z, op, 'mindist', 0.15, 'nmax', 3000 );
%  induced and incoming electric field
e = emesh( sig ) + emesh( dip.field( emesh.pt, enei ) );
%  norm of electric field
ee = sqrt( dot( e, e, 3 ) );

%%  final plot
%  plot electric field
imagesc( x( : ), z( : ), log10( ee ) );  hold on
plot( [ min( x( : ) ), max( x( : ) ) ], [ 0, 0 ], 'w--' );
%  dipole position
plot( pt.pos( 1 ), pt.pos( 3 ), 'mo', 'MarkerFaceColor', 'm' );

%  Cartesian coordinates of Poynting vector
[ sx, sy ] = pol2cart( theta, 8 * s / max( s ) );
%  overlay with Poynting vector
plot( sx, sy, 'w-', 'LineWidth', 1 );

colorbar;  colormap hot( 255 );
caxis( [ - 2, 2 ] );

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );

title( 'Electric field (logarithmic), radiation pattern' );

set( gca, 'YDir', 'norm' );
axis equal tight
