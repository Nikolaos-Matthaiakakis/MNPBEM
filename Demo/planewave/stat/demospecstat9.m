%  DEMOSPECSTAT9 - Field enhancement for coupled nanotriangles (bowtie).
%    For two metallic nanotriangles (bowtie geometry) and an incoming plane
%    wave with a polarization along x, this program computes and plots the
%    field enhancement within the quasistatic approximation.  We show how
%    to plot fields on the particle boundaries and how to set up a plate
%    around the nanotriangle, using the POLYGON3 class, on which we plot
%    the electric fields.
%
%  Runtime on my computer:  13.7 sec.

%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' );
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epstable( 'gold.dat' ) };

%  polygon for triangle
poly = round( polygon( 3, 'size', [ 30, 2 / sqrt( 3 ) * 30 ] ) );
%  edge profile for triangle
edge = edgeprofile( 5, 11 );
%  extrude polygon to nanoparticle
[ p1, poly1 ] = tripolygon( poly, edge );
%  shift vector
vec = [ - min( p1.pos( :, 1 ) ) + 2, 0, 0 ];
%  shift nanoparticle and polygon
[ p1, poly1 ] = deal( shift( p1, vec ), shift( poly1, vec ) );
%  flip second polygon
[ p2, poly2 ] = deal( flip( p1, 1 ), flip( poly1, 1 ) );

%  set up COMPARTICLE object
p = comparticle( epstab, { p1, p2 }, [ 2, 1; 3, 1 ], 1, 2, op );

%%  BEM simulation and plot of electric field on particle
%  set up BEM solver
bem = bemsolver( p, op );

%  plane wave excitation
exc = planewave( [ 1, 0, 0 ], [ 0, 0, 1 ], op );
%  light wavelength in vacuum
enei = 650;
%  surface charge
sig = bem \ exc( p, enei );

%  electric field
f = field( bem, sig );
%  plot norm of induced electric field
plot( p, vecnorm( f.e ) );  
%  add colorbar
colorbar;

%%  plot electric field around particle
%  In the following we show how to make a plate around the nanotriangles,
%  using the POLYGON3 class, and to compute the electric field at the plate
%  vertices.

%  change z-value polygon returned by TRIPOLYGON and shift boundaries to
%  outside
poly1 = shiftbnd( set( poly1, 'z', -2 ), 0.5 );
poly2 = shiftbnd( set( poly2, 'z', -2 ), 0.5 );
%  change direction of polygons so that they become the inner plate
%  boundaries
poly1 = set( poly1, 'dir', -1 );
poly2 = set( poly2, 'dir', -1 );
%  outer plate boundary
poly3 = polygon3( polygon( 4, 'size', [ 80, 50 ] ), -2 );
%  make plate
eplate = plate( [ poly1, poly2, poly3 ] );

%  make COMPOINT object with plate positions
pt = compoint( p, eplate.verts );
%  set up Green function object between PT and P
g = greenfunction( pt, p, op );

%  induced electric field at plate vertices
fplate = field( g, sig );
%  plot norm of electric field
plot( eplate, vecnorm( fplate.e ) );
