%  DEMOSPECRET15 - Light scattering of nanosphere with mirror symmetry.
%    For a metallic nanosphere and an incoming plane wave, this program
%    computes the scattering cross section for different light wavelengths
%    and for the full Maxwell equations, exploiting the mirror symmetry of
%    the sphere.  The results are compared with Mie theory.
%
%  Runtime on my computer:  13.1 sec.

%%  initialization
%  options for BEM simulation with mirror symmetry
op = bemoptions( 'sim', 'ret', 'interp', 'curv', 'sym', 'xy' );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };
%  diameter of sphere
diameter = 150;
%  one quarter of a sphere
p = trispheresegment( linspace( 0, pi / 2, 10 ), linspace( 0, pi, 20 ), diameter );
%  initialize sphere with mirror symmetry
p = comparticlemirror( epstab, { p }, [ 2, 1 ], 1, op );

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
