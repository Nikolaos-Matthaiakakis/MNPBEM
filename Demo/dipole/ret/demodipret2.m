%  DEMODIPRET2 - Energy dependent lifetime for dipole above a nanosphere.
%    For a metallic nanosphere and an oscillating dipole located above the
%    sphere, with a dipole moment oriented along x or z, this program
%    computes the total and radiative dipole scattering rates for different
%    dipole transition energies using the full Maxwell equations, and
%    compares the results with Mie theory.
%
%  Runtime on my computer:  60 sec.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv' );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };
%  diameter of sphere
diameter = 150;
%  nanosphere with finer discretization at the top
p = trispheresegment( 2 * pi * linspace( 0, 1, 31 ),  ...
                          pi * linspace( 0, 1, 31 ) .^ 2, diameter );
%  initialize sphere
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

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
ylabel( 'Total decay rate' );

%%  comparison with Mie theory
mie = miesolver( epstab{ 2 }, epstab{ 1 }, diameter, op );
%  total and radiative decay rate
[ tot0, rad0 ] = deal( zeros( numel( enei ), 2 ) );

%  loop over energies
for ien = 1 : numel( enei )
  [ tot0( ien, : ), rad0( ien, : ) ] =  ...
    mie.decayrate( enei( ien ), pt.pos( :, 3 ) );
end

if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
plot( enei, tot0, '--'  );
if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
plot( enei, rad0, 'o--' ); 

legend( 'tot(x) @ BEM', 'tot(z) @ BEM',  ...
        'rad(x) @ BEM', 'rad(z) @ BEM', 'tot(x) @ Mie' );
