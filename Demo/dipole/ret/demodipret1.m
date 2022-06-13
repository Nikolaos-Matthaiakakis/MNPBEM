%  DEMODIPRET1 - Lifetime reduction for dipole above metallic nanosphere.
%    For a metallic nanosphere and an oscillating dipole located above the
%    sphere, with a dipole moment oriented along x or z, this program
%    computes the total and radiative dipole scattering rates using the
%    full Maxwell equations, and compares the results with Mie theory.
%
%  Runtime on my computer:  3 sec.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv' );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };
%  diameter of sphere
diameter = 150;
%  initialize sphere
p = comparticle( epstab, { trisphere( 144, diameter ) }, [ 2, 1 ], 1, op );

%%  dipole oscillator
enei = 550;
%  positions of dipole
z = reshape( linspace( 0.6, 1.5, 51 ) * diameter, [], 1 );
%  compoint
pt = compoint( p, [ 0 * z, 0 * z, z ] );
%  dipole excitation
dip = dipole( pt, [ 1, 0, 0; 0, 0, 1 ], op );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );
%  surface charge
sig = bem \ dip( p, enei );
%  total and radiative decay rate
[ tot, rad ] = dip.decayrate( sig );

%%  final plot
semilogy( z, tot, '-'  );  hold on;
if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
semilogy( z, rad, 'o-' ); 

xlim( [ min( z ), max( z ) ] );

title( 'Total and radiaitve decay rate for dipole oriented along x and z' );

xlabel( 'Position (nm)' );
ylabel( 'Decay rate' );

%%  comparison with Mie theory
mie = miesolver( epstab{ 2 }, epstab{ 1 }, diameter, op );
%  total and radiative decay rate
[ tot0, rad0 ] = mie.decayrate( enei, z );

if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
semilogy( z, tot0, '--'  );
if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
semilogy( z, rad0, 'o--' ); 

legend( 'tot(x) @ BEM', 'tot(z) @ BEM', 'rad(x) @ BEM', 'rad(z) @ BEM',  ...
        'tot(x) @ Mie', 'tot(z) @ Mie', 'rad(x) @ Mie', 'rad(z) @ Mie' );
