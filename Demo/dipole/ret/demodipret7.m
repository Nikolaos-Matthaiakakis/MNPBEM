%  DEMODIPRET7 - Electric field for dipole above coated nanosphere.
%    For a coated metallic nanosphere (50 nm glass sphere coated with 10 nm
%    thick silver shell) and an oscillating dipole located above the
%    sphere, with a dipole moment oriented along z and the transition
%    energy tuned to the plasmon resonance, this program computes the
%    electric field map and the emission pattern using the full Maxwell
%    equations.
%
%  Runtime on my computer:  17 sec.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv' );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 2.25 ) };
%  diameter of sphere
diameter = 50;
%  nanospheres
p1 = trisphere( 144, diameter      );
p2 = trisphere( 256, diameter + 10 );
%  initialize sphere
p = comparticle( epstab, { p1, p2 }, [ 3, 2; 2, 1 ], 1, 2, op );

%%  dipole oscillator
%  dipole transition energy tuned to plasmon resonance frequency
%    plasmon resonance extracted from DEMODIPRET7
enei = 640;
%  compoint
pt = compoint( p, [ 0, 0, 0.7 * diameter ] );
%  dipole excitation
dip = dipole( pt, [ 0, 0, 1 ], op );
%  initialize total and radiative scattering rate
[ tot, rad ] = deal( zeros( numel( enei ), 2 ) );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );
%  surface charge
sig = bem \ dip( p, enei );

%%  emission pattern
%  angles
theta = reshape( linspace( 0, 2 * pi, 101 ), [], 1 );
%  directions for emission
dir = [ cos( theta ), 0 * theta, sin( theta ) ];
%  set up spectrum object
spec = spectrum( dir, op );

%  farfield radiation
f = farfield( spec, sig );
%  norm of Poynting vector
s = vecnorm( 0.5 * real( cross( f.e, conj( f.h ), 2 ) ) );

%%  computation of electric field
%  mesh for calculation of electric field
[ x, z ] = meshgrid( linspace( - 60, 60, 81 ) );
%  object for electric field
%    MINDIST controls the minimal distance of the field points to the
%    particle boundary
emesh = meshfield( p, x, 0, z, op, 'mindist', 0.5 );
%  induced and incoming electric field
e = emesh( sig ) + emesh( dip.field( emesh.pt, enei ) );
%  norm of electric field
ee = sqrt( sum( abs( e ) .^ 2, 3 ) );

%%  final plot
%  plot electric field
imagesc( x( : ), z( : ), log10( ee ) );  hold on
%  dipole position
plot( pt.pos( 1 ), pt.pos( 3 ), 'mo', 'MarkerFaceColor', 'm' );

colorbar;  colormap hot( 255 );
caxis( [ - 4, - 1 ] );

%  Cartesian coordinates of Poynting vector
[ sx, sy ] = pol2cart( theta, 50 * s / max( s ) );
%  overlay with Poynting vector
plot( sx, sy, 'w--', 'LineWidth', 1 );

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );

title( 'Electric field (logarithmic), radiation pattern' );

set( gca, 'YDir', 'norm' );
axis equal tight
