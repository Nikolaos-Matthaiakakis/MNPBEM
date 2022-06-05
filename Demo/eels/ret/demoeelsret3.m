%  DEMOEELSRET3 - Induced electric field for EELS of nanodisk.
%    For a silver nanodisk with 60 nm diameter and 10 nm height, this
%    program computes the induced electric field for an electron beam
%    excitation for two selected impact parameters (inside and outside of
%    disk) along the electron beam trajectory, using the full Maxwell
%    equations.
%
%  Runtime on my computer:  8 sec.

%% initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv' );
%  table of dielectric function
epstab = { epsconst( 1 ), epstable( 'silver.dat' ) };

%  diameter of disk
diameter = 60;
%  polygon for disk
poly = polygon( 25, 'size', [ 1, 1 ] * diameter );
%  edge profile for disk
edge = edgeprofile( 10, 11 );
%  extrude polygon to nanoparticle
p = comparticle( epstab, { tripolygon( poly, edge ) }, [ 2, 1 ], 1, op );

%  width of electron beam and electron velocity
[ width, vel ] = deal( 0.5, eelsbase.ene2vel( 200e3 ) );
%  impact parameters 
%  impact parameters
imp = [ 0.9, 1.2 ] * diameter / 2;  
%  loss energies in eV
ene = 2.6;

%  convert energies to nm
units;  enei = eV2nm ./ ene;

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, enei, op );
%  EELS excitation
exc1 = electronbeam( p, [ imp( 1 ), 0 ], width, vel, op );
exc2 = electronbeam( p, [ imp( 2 ), 0 ], width, vel, op );

%  z-values where field is computed
z = linspace( - 80, 80, 1001 ) .';
%  convert to points
pt1 = compoint( p, [ imp( 1 ) + 0 * z, 0 * z, z ], 'mindist', 0.1 ); 
pt2 = compoint( p, [ imp( 2 ) + 0 * z, 0 * z, z ], 'mindist', 0.1 ); 
%  Green function object
g1 = greenfunction( pt1, p, op );
g2 = greenfunction( pt2, p, op );

%  compute surface charges
sig1 = bem \ exc1( enei );
sig2 = bem \ exc2( enei );
%  compute fields
field1 = g1.field( sig1 ); 
field2 = g2.field( sig2 );
%  electric field
e1 = pt1( field1.e );
e2 = pt2( field2.e );

%%  final plot
plot( z, real( e1( :, 3 ) ), z, real( e2( :, 3 ) ) );  hold on;

plot( [ - 5, - 5 ], 10 * [ - 1, 1 ], 'k--' );
plot( [   5,   5 ], 10 * [ - 1, 1 ], 'k--' );

ylim( [ - 4, 4 ] );

legend( 'inside', 'outside' );

xlabel( 'z (nm)' );
ylabel( 'Electric field' );

