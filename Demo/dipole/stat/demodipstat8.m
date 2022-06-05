%  DEMODIPSTAT8 - Electric field for dipole close to nanodisk and layer.
%    For a silver nanodisk with a diameter of 30 nm and a height of 5 nm,
%    and a dipole oscillator with dipole orientation along x and located 5
%    nm away from the disk and 0.5 nm above the substrate, this program
%    computes the radiation pattern and the total electric field using the
%    quasistatic approximation.
%
%  Runtime on my computer:  23 sec.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'silver.dat' ), epsconst( 4 ) };
%  location of interface of substrate
ztab = 0;

%  default options for layer structure
op = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, op );
%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' , 'layer', layer );

%  polygon for disk
poly = polygon( 25, 'size', [ 30, 30 ] );
%  edge profile for nanodisk
%    MODE '01' produces a rounded edge on top and a sharp edge on bottom,
%    MIN controls the lower z-value of the nanoparticle 
edge = edgeprofile( 5, 11, 'mode', '01', 'min', 1e-3 );
%  use finer discretization at (R,0,0)
refun = @( pos, d ) 0.5 + abs( 15 - pos( :, 1 ) );
%  extrude polygon to nanoparticle
p = tripolygon( poly, edge, 'refun', refun );

%  set up COMPARTICLE object
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%%  dipole oscillator
enei = 570;
%  positions of dipole
x = max( p.pos( :, 1 ) ) + 2;
%  compoint
pt = compoint( p, [ x, 0 * x, 0 * x + 0.5 ], op );
%  dipole excitation
dip = dipole( pt, [ 1, 0, 0 ], op );

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
[ x, z ] = meshgrid( linspace( - 30, 30, 81 ) );
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
[ sx, sy ] = pol2cart( theta, 20 * s / max( s ) );
%  overlay with Poynting vector
plot( sx, sy, 'w-', 'LineWidth', 1 );

colorbar;  colormap hot( 255 );
caxis( [ - 3, 1 ] );

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );

title( 'Electric field (logarithmic), radiation pattern' );

set( gca, 'YDir', 'norm' );
axis equal tight
