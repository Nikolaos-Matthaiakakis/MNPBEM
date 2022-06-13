%  DEMOSPECRET12 - Nearfield enhancement for two nanospheres in layer.
%    For two metallic nanospheres with a diameter of 8 nm and a 1 nm gap,
%    embedded inside a 10 nm thick glass layer on top of a substrate, and
%    an incoming plane wave, this program computes the nearfield
%    enhancement at the resonance wavelength of 600 nm using the full
%    Maxwell equations.
%
%  Runtime on my computer:  66 sec.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ),  ...
           epstable( 'gold.dat' ), epsconst( 2.5 ), epsconst( 10 ) };
%  location of interface of substrate
ztab = [ 10, 0 ];

%  default options for layer structure
op = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 4, 5 ], ztab, op );
%  options for BEM simulations
op = bemoptions( 'sim', 'ret',  'interp', 'curv' , 'layer', layer );

%  radius of spheres
a = 4;
%  coupled nanospheres
p1 = shift( trisphere( 144, 2 * a ), [   a + 0.5, 0, a + 1 ] );
p2 = shift( trisphere( 144, 2 * a ), [ - a - 0.5, 0, a + 1 ] );

%  set up COMPARTICLE objects
p = comparticle( epstab, { p1, p2 }, [ 2, 4; 3, 4  ], 1, 2, op );

%  light propagation angle
theta = pi / 180 * reshape( 40, [], 1 );
%  TM mode, excitation from above
dir = [ sin( theta ), 0 * theta, - cos( theta ) ];
pol = [ cos( theta ), 0 * theta,   sin( theta ) ];
%  wavelength of light
enei = 600;

%%  tabulated Green functions
%  For the retarded simulation we first have to set up a table for the
%  calculation of the reflected Green function.  This part is usually slow
%  and we thus compute GREENTAB only if it has not been computed before.

%  For setting up the table for the reflected Green function, we need to
%  provide all points for which we will compute it.  As we will compute the
%  nearfield enhancement above and below the layer interfaces using the
%  MESHFIELD class, we here set up a COMPOINT object.  Note that the
%  MESHFIELD object must be initialized later because it needs the
%  precomputed Green function table.
[ x, z ] = meshgrid( linspace( - 15, 15, 101 ), linspace( - 10, 20, 101 ) );
%  make COMPOINT object
%    it is important that COMPOINT receives the OP structure because it has
%    to group the points within the layer structure
pt = compoint( p, [ x( : ), 0 * x( : ), z( : ) + 1e-3 ], op );

if ~exist( 'greentab', 'var' ) || ~greentab.ismember( layer, enei, p, pt )
  %  automatic grid for tabulation
  %    we use a rather small number NZ for tabulation to speed up the
  %    simulations
  tab = tabspace( layer, p, pt, 'nz', 10 );
  %  Green function table
  greentab = compgreentablayer( layer, tab );
  %  precompute Green function table
  greentab = set( greentab, enei, op );
end
op.greentab = greentab;

%%  BEM solver
%  initialize BEM solver
bem = bemsolver( p, op );
%  initialize plane wave excitation
exc = planewave( pol, dir, op );
%  solve BEM equation
sig = bem \ exc( p, enei );

%%  computation of electric field
%  object for electric field
%    MINDIST controls the minimal distance of the field points to the
%    particle boundary
emesh = meshfield( p, x, 0, z + 1e-3, op, 'mindist', 0.15, 'nmax', 2000 );
%  induced and incoming electric field
e = emesh( sig ) + emesh( exc.field( emesh.pt, enei ) );
%  norm of electric field
ee = sqrt( dot( e, e, 3 ) );

%%  final plot
%  plot electric field
imagesc( x( : ), z( : ), log10( ee ) );  hold on

plot( [ min( x( : ) ), max( x( : ) ) ], ztab( 1 ) * [ 1, 1 ], 'w--' );
plot( [ min( x( : ) ), max( x( : ) ) ], ztab( 2 ) * [ 1, 1 ], 'w--' );

colorbar;  colormap hot( 255 );

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );

title ( 'Field enhancement (logarithmic)' );

set( gca, 'YDir', 'norm' );
axis equal tight
