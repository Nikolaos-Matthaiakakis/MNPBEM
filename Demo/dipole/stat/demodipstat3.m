%  DEMODIPSTAT3 - Electric field for dipole above metallic nanosphere.
%    For a metallic nanosphere and an oscillating dipole located above the
%    sphere, with a dipole moment oriented along z, this program computes
%    the total electric field.
%
%  Runtime on my computer:  3.8 sec.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'waitbar', 0, 'interp', 'curv' );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };
%  diameter of sphere
diameter = 10;
%  initialize sphere
p = comparticle( epstab, { trisphere( 144, diameter ) }, [ 2, 1 ], 1, op );

%%  dipole oscillator
enei = 550;
%  compoint
pt = compoint( p, [ 0, 0, 0.8 * diameter ] );
%  dipole excitation
dip = dipole( pt, [ 0, 0, 1 ], op );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );
%  surface charge
sig = bem \ dip( p, enei );

%%  computation of electric field
%  mesh for calculation of electric field
[ x, z ] = meshgrid( linspace( - 15, 15, 81 ) );
%  object for electric field
%    MINDIST controls the minimal distance of the field points to the
%    particle boundary
emesh = meshfield( p, x, 0, z, op, 'mindist', 0.15 );
%  induced and incoming electric field
e = emesh( sig ) + emesh( dip.field( emesh.pt, enei ) );
%  norm of electric field
ee = sqrt( dot( e, e, 3 ) );

%%  final plot
%  plot electric field
imagesc( x( : ), z( : ), log10( ee ) );  hold on
%  dipole position
plot( pt.pos( 1 ), pt.pos( 3 ), 'mo', 'MarkerFaceColor', 'm' );

colorbar;  colormap hot( 255 );
caxis( [ - 3, 1 ] );

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );

title( 'Electric field (logarithmic)' );

set( gca, 'YDir', 'norm' );
axis equal tight

