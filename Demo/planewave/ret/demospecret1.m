%  DEMOSPECRET1 - Light scattering of metallic nanosphere.
%    For a metallic nanosphere and an incoming plane wave, this program
%    computes the scattering cross section for different light wavelengths
%    using the full Maxwell equations, and compares the results with Mie
%    theory.
%
%  Runtime on my computer:  7.4 sec.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv' );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };
%  diameter of sphere
diameter = 150;
%  initialize sphere
p = comparticle( epstab, { trisphere( 144, diameter ) }, [ 2, 1 ], 1, op );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );

%  plane wave excitation
exc = planewave( [ 1, 0, 0; 0, 1, 0 ], [ 0, 0, 1; 0, 0, 1 ], op );
%  light wavelength in vacuum
enei = linspace( 400, 900, 40 );
%  allocate scattering and extinction cross sections
sca = zeros( length( enei ), 2 );
ext = zeros( length( enei ), 2 );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charge
  sig = bem \ exc( p, enei( ien ) );
  %  scattering and extinction cross sections
  sca( ien, : ) = exc.sca( sig );
  ext( ien, : ) = exc.ext( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( enei, sca, 'o-'  );  hold on;

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section (nm^2)' );

%%  comparison with Mie theory
mie = miesolver( epstab{ 2 }, epstab{ 1 }, diameter, op );

plot( enei, mie.sca( enei ), '--' );  hold on

legend( 'BEM : x-polarization', 'BEM : y-polarization', 'Mie theory' );
