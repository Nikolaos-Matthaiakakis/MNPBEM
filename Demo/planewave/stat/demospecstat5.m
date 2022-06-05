%  DEMOSPECSTAT5 - Light scattering of nanotriangle.
%    For a metallic nanotriangle and an incoming plane wave with a
%    polarization along x and y, this program computes the scattering cross
%    sections for different light wavelengths within the quasistatic
%    approximation,
%
%  Runtime on my computer:  7.3 sc.

%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' );
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };

%  polygon for triangle
poly = round( polygon( 3, 'size', [ 30,  2 / sqrt( 3 ) * 30 ] ) );
%  edge profile for triangle
edge = edgeprofile( 5, 11 );
%  extrude polygon to nanoparticle
p = tripolygon( poly, edge );

%  set up COMPARTICLE objects
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );

%  plane wave excitation
exc = planewave( [ 1, 0, 0; 0, 1, 0 ], [ 0, 0, 1; 0, 0, 1 ], op );
%  light wavelength in vacuum
enei = linspace( 500, 750, 40 );
%  allocate scattering and extinction cross sections
sca = zeros( length( enei ), 2 );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charge
  sig = bem \ exc( p, enei( ien ) );
  %  scattering cross sections
  sca( ien, : ) = exc.sca( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( enei, sca, 'o-'  );  hold on;

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section (nm^2)' );

legend( 'x-pol', 'y-pol' );
