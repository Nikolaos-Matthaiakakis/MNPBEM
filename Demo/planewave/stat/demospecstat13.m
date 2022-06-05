%  DEMOSPECSTAT13 - Field enhancement for metallic disk above substrate.
%    We consider a metallic nanodisk with a diameter of 30 nm and a height
%    of 5 nm located on top of a substrate, and an incoming plane wave
%    with TM polarization and an excitation angle of 40 degrees.  This
%    program first computes within the quasistatic approximation the
%    surface charge at the resonance wavelength of 660 nm, and then the
%    electric fields above and within the substrate.
%
%  Runtime on my computer:  13 sec.

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
%    through REFINE we choose a higher number of integration points per
%    boundary element, to get an accurate field calculation for points
%    situated close to the particle boundary
op = bemoptions( 'sim', 'stat', 'interp', 'curv',  ...
                                'layer', layer, 'refine', 2 );

%  polygon for disk
poly = polygon( 25, 'size', [ 30, 30 ] );
%  edge profile for nanodisk
%    MODE '01' produces a rounded edge on top and a sharp edge on bottom,
%    MIN controls the lower z-value of the nanoparticle 
edge = edgeprofile( 5, 11, 'mode', '01', 'min', 1e-3 );
%  extrude polygon to nanoparticle
p = tripolygon( poly, edge );

%  set up COMPARTICLE objects
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%  light propagation angles
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
enei = 660;
%  surface charge
sig = bem \ exc( p, enei );

%%  computation of electric field
%  mesh for calculation of electric field
%    we add to the grid z-values a small quantity to push points at the
%    interface into the lower substrate
[ x, z ] = meshgrid( linspace( - 20, 20, 61 ), linspace( - 15, 15, 81 ) - 1e-3 );
%  object for electric field
%    MINDIST controls the minimal distance of the field points to the
%    particle boundary, through NMAX it is possible to compute the electric
%    fields in portions and to work with less computer memory
emesh = meshfield( p, x, 0, z, op, 'mindist', 0.2, 'nmax', 2000 );
%  induced and incoming electric field
e = emesh( sig ) + emesh( exc.field( emesh.pt, enei ) );
%  norm of electric field
ee = sqrt( dot( e, e, 3 ) );

%%  final plot
%  plot electric field
imagesc( x( : ), z( : ), ee );  hold on;
plot( [ min( x( : ) ), max( x( : ) ) ], [ 0, 0 ], 'w--' );

colorbar;  colormap hot( 255 );

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );

set( gca, 'YDir', 'norm' );
axis equal tight
