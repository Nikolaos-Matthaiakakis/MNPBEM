%  DEMOSPECRET10 - Nearfield enhancement for metallic nanodisk on substrate.
%    For a metallic nanodisk with a diameter of 60 nm located on top of a
%    substrate and an incoming plane wave, with TM polarization and
%    different excitation angles, this program first computes the surface
%    charges at a wavelength of 660 nm, and then the electric fields in a
%    plane above the nanparticle using the full Maxwell equations.
%
%  Runtime on my computer:  49 sec.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 2.5 ) };
%  location of interface of substrate
ztab = 0;

%  default options for layer structure
op = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, op );
%  options for BEM simulations
op = bemoptions( 'sim', 'ret',  'interp', 'curv' , 'layer', layer );

%  polygon for disk
poly = polygon( 25, 'size', [ 80, 78 ] );
%  edge profile for nanodisk
%    MODE '01' produces a rounded edge on top and a sharp edge on bottom,
%    MIN controls the lower z-value of the nanoparticle 
edge = edgeprofile( 10, 11, 'mode', '01', 'min', 1e-3 );
%  extrude polygon to nanoparticle
p = tripolygon( poly, edge );

%  set up COMPARTICLE objects
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%  light propagation angles
theta = pi / 180 * reshape( linspace( 0, 80, 5 ), [], 1 );
%  TM mode, excitation from above
dir = [ sin( theta ), 0 * theta, - cos( theta ) ];
pol = [ cos( theta ), 0 * theta,   sin( theta ) ];
%  photon wavelength
enei = 660;

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
[ x, y ] = meshgrid( linspace( - 60, 60, 41 ) );
%  make compoint object
%    it is important that COMPOINT receives the OP structure because it has
%    to group the points within the layer structure
pt = compoint( p, [ x( : ), y( : ), 0 * x( : ) + 15 ], op );

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
%  electromagnetic fields at boundary
e1 = subsref( field( bem, sig ), substruct( '.', 'e' ) );

%%  computation of electric field
%  object for electric field
%    MINDIST controls the minimal distance of the field points to the
%    particle boundary, MESHFIELD must receive the OP structure which also
%    stores the table of precomputed reflected Green functions
emesh = meshfield( p, pt.pos( :, 1 ), pt.pos( :, 2 ), pt.pos( :, 3 ),  ...
                                                          op, 'nmax', 2000 );
%  induced and incoming electric field
e2 = emesh( sig ) + emesh( exc.field( emesh.pt, enei ) );

%%  final plot
%  plot particle
plot( p, 'FaceAlpha', 0.5 );
%  plot fields in xy-plane above nanodisk
coneplot( pt.pos, e2, 'scale', 2 );
