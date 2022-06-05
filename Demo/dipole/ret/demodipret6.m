%  DEMODIPRET6 - Lifetime reduction for dipole above a coated nanosphere.
%    For a coated metallic nanosphere (50 nm glass sphere coated with 10 nm
%    thick silver shell) and an oscillating dipole located above the
%    sphere, with a dipole moment oriented along x or z, this program
%    computes the total and radiative dipole scattering rates for different
%    dipole transition energies using the full Maxwell equations.
%
%  Runtime on my computer:  67 sec.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv' );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 2.25 ) };
%  diameter of sphere
diameter = 50;
%  nanospheres
p1 = trisphere( 144, diameter      );
p2 = trisphere( 256, diameter + 10 );
%  initialize sphere
p = comparticle( epstab, { p1, p2 }, [ 3, 2; 2, 1 ], 1, 2, op );

%%  dipole oscillator
enei = linspace( 400, 900, 40 );
%  compoint
pt = compoint( p, [ 0, 0, 0.7 * diameter ] );
%  dipole excitation
dip = dipole( pt, [ 1, 0, 0; 0, 0, 1 ], op );
%  initialize total and radiative scattering rate
[ tot, rad ] = deal( zeros( numel( enei ), 2 ) );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charge
  sig = bem \ dip( p, enei( ien ) );
  %  total and radiative decay rate
  [ tot( ien, : ), rad( ien, : ) ] = dip.decayrate( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( enei, tot       );  hold on;
if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
plot( enei, rad, 'o-' ); 

xlabel( 'Wavelength (nm)' );
ylabel( 'Decay rate' );

legend( 'tot(x)', 'tot(z)', 'rad(x)', 'rad(z)' );
