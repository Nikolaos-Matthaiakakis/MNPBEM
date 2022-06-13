%  DEMOSPECRET7 - Field enhancement of metallic nanosphere above substrate.
%    For a metallic nanosphere with a diameter of 40 nm located 5 nm above
%    a substrate and an incoming plane wave, with TM polarization and
%    oblique incidence, this program first computes the surface charges at
%    a wavelength of 520 nm, and then the emission pattern and the electric
%    fields above and within the substrate using the full Maxwell
%    equations.
%
%  Runtime on my computer:  31 sec.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 2.25 ) };
%  location of interface of substrate
ztab = 0;

%  default options for layer structure
op = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, op );
%  options for BEM simulations
op = bemoptions( 'sim', 'ret',  'interp', 'curv' , 'layer', layer );

%  initialize nanosphere
p = trisphere( 256, 40 );
%  shift nanosphere 5 nm above substrate
p = shift( p, [ 0, 0, - min( p.pos( :, 3 ) ) + 5 + ztab ] ); 

%  set up COMPARTICLE object
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%  light propagation angles
theta = pi / 180 * reshape( 40, [], 1 );
%  TM mode, excitation from above
dir = [ sin( theta ), 0 * theta, - cos( theta ) ];
pol = [ cos( theta ), 0 * theta,   sin( theta ) ];
%  light wavelength
enei = 520;

%%  tabulated Green functions
%  For the retarded simulation we first have to set up a table for the
%  calculation of the reflected Green function.  This part is usually slow
%  and we thus compute GREENTAB only if it has not been computed before.

%  For setting up the table for the reflected Green function, we need to
%  provide all points for which we will compute it.  As we will compute the
%  nearfield enhancement above and below the substrate interface using the
%  MESHFIELD class, we here set up a COMPOINT object.  Note that the
%  MESHFIELD object must be initialized later because it needs the
%  precomputed Green function table.
[ x, z ] = meshgrid( linspace( - 30, 30, 81 ), linspace( - 30, 60, 101 ) );
%  make compoint object
%    it is important that COMPOINT receives the OP structure because it has
%    to group the points within the layer structure
pt = compoint( p, [ x( : ), 0 * x( : ), z( : ) ], op );

if ~exist( 'greentab', 'var' ) || ~greentab.ismember( layer, enei, p, pt )
  %  automatic grid for tabulation
  %    we use a rather small number NZ for tabulation to speed up the
  %    simulations
  tab = tabspace( layer, p, pt, 'nz', 5 );
  %  Green function table
  greentab = compgreentablayer( layer, tab );
  %  precompute Green function table
  greentab = set( greentab, enei, op, 'waitbar', 0 );
end
op.greentab = greentab;

%%  BEM solver
%  initialize BEM solver
bem = bemsolver( p, op );
%  initialize plane wave excitation
exc = planewave( pol, dir, op );
%  solve BEM equation
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
%  object for electric field
%    MINDIST controls the minimal distance of the field points to the
%    particle boundary, MESHFIELD must receive the OP structure which also
%    stores the table of precomputed reflected Green functions
emesh = meshfield( p, x, 0, z, op, 'mindist', 0.5, 'nmax', 2000 );
%  induced and incoming electric field
e = emesh( sig ) + emesh( exc.field( emesh.pt, enei ) );
%  norm of electric field
ee = sqrt( dot( e, e, 3 ) );

%%  final plot
%  plot electric field
imagesc( x( : ), z( : ), ee ); hold on;
plot( [ min( x( : ) ), max( x( : ) ) ], [ 0, 0 ], 'w--' );

%  Cartesian coordinates of Poynting vector
[ sx, sy ] = pol2cart( theta, 30 * s / max( s ) );
%  overlay with Poynting vector
plot( sx, sy, 'w-', 'LineWidth', 1 );

colorbar;  colormap hot( 255 );

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );

title( 'Electric field, radiation pattern' );

set( gca, 'YDir', 'norm' );
axis equal tight
