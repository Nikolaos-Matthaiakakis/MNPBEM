%  DEMOSPECSTAT7 - Plasmonic eigenmodes for nanodisk.
%    We compute the plasmonic eigenmodes for a nanodisk, using the
%    PLASMONMODE function, and plot the eigenmodes.
%
%  Runtime on my computer:  5.6 sec.

%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' );
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };

%  polygon for disk
poly = polygon( 30, 'size', [ 30, 30 ] );
%  edge profile for triangle
edge = edgeprofile( 5, 11 );
%  extrude polygon to nanoparticle
[ p, poly ] = tripolygon( poly, edge );

%  set up COMPARTICLE objects
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );
%  compute eigenenergies and eigenmodes
[ ene, ur ] = plasmonmode( p, 20, op );

%  we next plot the eigenmodes
%    the green arrows at the top of the figure allow to page through the
%    different eigenmodes
plot( p, ur );
