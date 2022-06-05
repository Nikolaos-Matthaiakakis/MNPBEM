%  DEMODIPRET9 - Electric field for dipole between sphere and layer.
%    For a metallic nanosphere with a diameter of 4 nm located 1 nm above a
%    substrate and a dipole located between sphere and layer, this program
%    computes the radiation pattern and the total electric field using the
%    full Maxwell equations.
%
%  Runtime on my computer:  50 sec.

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
op = bemoptions( 'sim', 'ret', 'interp', 'curv' , 'layer', layer );

%  nanosphere with finer discretization at the bottom
p = flip( trispheresegment( 2 * pi * linspace( 0, 1, 31 ),  ...
                                pi * linspace( 0, 1, 31 ) .^ 2, 4 ), 3 );
%  place nanosphere 1 nm above substrate
p = shift( p, [ 0, 0, - min( p.pos( :, 3 ) ) + 1 + ztab ] ); 

%  set up COMPARTICLE objec
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%%  tabulated Green function
%  For the retarded simulation we first have to set up a table for the
%  calculation of the reflected Green function.  This part is usually slow
%  and we thus compute GREENTAB only if it has not been computed before.
%
%  For setting up the table for the reflected Green function, we need to
%  provide all points for which we will compute it.  As we will compute the
%  nearfield enhancement above and below the substrate interface using the
%  MESHFIELD class, we here set up a COMPOINT object.  Note that the
%  MESHFIELD object must be initialized later because it needs the
%  precomputed Green function table.
%
%  As we also want to compute the electromagnetic fields of the dipole, we
%  have to register in TABSPACE the dipole positions as both source and
%  observation points.

%  dipole position
pt1 = compoint( p, [ 1, 0, 0.5 ], op );
%  mesh for calculation of electric field
[ x, z ] = meshgrid( linspace( - 8, 8, 81 ) );
%  make compoint object
%    it is important that COMPOINT receives the OP structure because it has
%    to group the points within the layer structure
pt2 = compoint( p, [ x( : ), 0 * x( : ), z( : ) ], op );
%  wavelength corresponding to transition dipole energy
enei = 550;

%  tabulated Green functions
%    For the retarded simulation we first have to set up a table for the
%    calculation of the reflected Green function.  This part is usually
%    slow and we thus compute GREENTAB only if it has not been computed
%    before.
if ~exist( 'greentab', 'var' ) || ~greentab.ismember( layer, enei, { p, pt1 }, pt2 )
  %  automatic grid for tabulation
  %    we use a rather small number NZ for tabulation to speed up the
  %    simulations
  tab = tabspace( layer, { p, pt1 }, pt2, 'nz', 5 );
  %  Green function table
  greentab = compgreentablayer( layer, tab );
  %  precompute Green function table
  greentab = set( greentab, enei, op, 'waitbar', 0 );
end
op.greentab = greentab;

%%  BEM simulation
%  dipole excitation
dip = dipole( pt1, [ 0, 0, 1 ], op );
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
% %  mesh for calculation of electric field
% [ x, z ] = meshgrid( linspace( - 8, 8, 81 ) );
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
plot( pt1.pos( 1 ), pt1.pos( 3 ), 'mo', 'MarkerFaceColor', 'm' );

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
