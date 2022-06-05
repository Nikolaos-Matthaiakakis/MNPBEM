%  DEMOSPECSTAT6 - Field enhancement for nanotriangle.
%    For a metallic nanotriangle and an incoming plane wave with a
%    polarization along y, this program computes and plots the field
%    enhancement within the quasistatic approximation.  We show how to plot
%    fields on the particle boundaries and how to set up a plate around the
%    nanotriangle, using the POLYGON3 class, on which we plot the electric
%    fields.
%
%  Runtime on my computer:  6.8 sec.

%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' );
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };

%  polygon for triangle
poly = round( polygon( 3, 'size', [ 30, 2 / sqrt( 3 ) * 30 ] ) );
%  edge profile for triangle
edge = edgeprofile( 5, 11 );
%  extrude polygon to nanoparticle
[ p, poly ] = tripolygon( poly, edge );

%  set up COMPARTICLE object
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%%  BEM simulation and plot of electric field on particle
%  set up BEM solver
bem = bemsolver( p, op );

%  plane wave excitation
exc = planewave( [ 0, 1, 0 ], [ 0, 0, 1 ], op );
%  light wavelength in vacuum
enei = 620;
%  surface charge
sig = bem \ exc( p, enei );

%  electric field
f = field( bem, sig );
%  plot norm of induced electric field
plot( p, vecnorm( f.e ) );  
%  add colorbar
colorbar;

%%  plot electric field around particle
%  In the following we show how to make a plate around the nanotriangle,
%  using the POLYGON3 class, and to compute the electric field at the plate
%  vertices.

%  change z-value polygon returned by TRIPOLYGON and shift boundaries to
%  outside
poly1 = shiftbnd( set( poly, 'z', -2 ), 1 );
%  change direction of polygon so that it becomes the inner plate boundary
poly1 = set( poly1, 'dir', -1 );
%  outer plate boundary
poly2 = polygon3( polygon( 4, 'size', [ 50, 50 ] ), -2 );
%  make plate
eplate = plate( [ poly1, poly2 ] );

%  make COMPOINT object with plate positions
pt = compoint( p, eplate.verts );
%  set up Green function object between PT and P
g = greenfunction( pt, p, op );

%  induced electric field at plate vertices
fplate = field( g, sig );
%  plot norm of electric field
plot( eplate, vecnorm( fplate.e ) );
