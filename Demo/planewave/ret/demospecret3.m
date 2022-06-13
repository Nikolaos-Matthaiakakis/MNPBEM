%  DEMOSPECRET3 - Field enhancement for nanodisk.
%    For a metallic nanodisk and an incoming plane wave with a polarization
%    along x, this program computes and plots the field enhancement using
%    the full Maxwell equations.  We show how to plot fields on the
%    particle boundaries and how to set up a plate around the nanodisk,
%    using the POLYGON3 class, on which we plot the electric fields.
%
%  Runtime on my computer:  20.7 sec.

%%  initializations
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv' );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };

%  polygon for disk
poly = polygon( 30, 'size', [ 30, 30 ] );
%  edge profile for nanodisk
edge = edgeprofile( 5, 11 );
%  extrude polygon to nanoparticle
[ p, poly ] = tripolygon( poly, edge );
%  initialize sphere
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%%  BEM simulation and plot of electric field on particle
%  set up BEM solver
bem = bemsolver( p, op );

%  plane wave excitation
exc = planewave( [ 1, 0, 0 ], [ 0, 0, 1 ], op );
%  light wavelength in vacuum
enei = 580;
%  surface charge
sig = bem \ exc( p, enei );

%  electric field
f = field( bem, sig );
%  plot norm of induced electric field
plot( p, vecnorm( f.e ) );  hold on;
%  add colorbar
colorbar;

%%  plot electric field around particle
%  In the following we show how to make a plate around the nanodisk,
%  using the POLYGON3 class, and to compute the electric field at the plate
%  vertices.

%  change z-value polygon returned by TRIPOLYGON and shift boundaries to
%  outside
poly1 = shiftbnd( set( poly, 'z', -2 ), 1 );
%  change direction of polygon so that it becomes the inner plate boundary
poly1 = set( poly1, 'dir', -1 );
%  outer plate boundary
poly2 = polygon3( polygon( 4, 'size', [ 60, 60 ] ), -2 );
%  make plate
eplate = plate( [ poly1, poly2 ] );

%  make COMPOINT object with plate positions
pt1 = compoint( p, eplate.verts );
%  set up Green function object between PT and P
g1 = greenfunction( pt1, p, op );

%  induced electric field at plate vertices
fplate = field( g1, sig );
%  plot norm of electric field
plot( eplate, vecnorm( fplate.e ) );

%%  overlay with quiver plot
%  grid for field vectors
[ x, y ] = meshgrid( linspace( - 30, 30, 31 ) );
%  make COMPOINT object with grid positions
pt2 = compoint( p, [ x( : ), y( : ), 0 * x( : ) - 2 ], op,  ...
                                            'mindist', 2, 'medium', 1 );
%  set up Green function
g2 = greenfunction( pt2, p, op );
%  electric field at grid positions
f2 = field( g2, sig );
%  normalized electric field
e2 = imag( vecnormalize( f2.e ) );
%  overlay graphics with quiver plot
quiver3( pt2.pos( :, 1 ), pt2.pos( :, 2 ), pt2.pos( :, 3 ),  ...
                        e2( :, 1 ), e2( :, 2 ), e2( :, 3 ), 0.5, 'w' );
