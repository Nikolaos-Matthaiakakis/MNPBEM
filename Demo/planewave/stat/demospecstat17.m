%  DEMOSPECSTAT17 - Light scattering of metallic nanorod.
%    For a metallic nanorod and an incoming plane wave, this program
%    computes the scattering cross section for different light wavelengths
%    within the quasistatic approximation using an iterative BEM solver.
%
%  Runtime on my computer:  4.5 minutes

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'stat' );
%  use iterative BEM solver
%    For comparison you might also like to run the program w/o iterative
%    solvers by commenting the next line.
op.iter = bemiter.options;

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };
%  nanorod
%    diameter 5 nm, length 300 nm, number of boundary elements 7378 
%    Note: For the given dimensions one should use a retarded BEM solver,
%    this demo file only shows the working principle of iterative solvers.
p = trirod( 5, 300, [ 15, 15, 500 ] );
%  initialize nanorod
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );

%  plane wave excitation
exc = planewave( [ 1, 0, 0; 0, 0, 1 ], [ 0, 0, 1; 1, 0, 0 ], op );
%  light wavelength in vacuum
enei = linspace( 500, 900, 30 );
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
