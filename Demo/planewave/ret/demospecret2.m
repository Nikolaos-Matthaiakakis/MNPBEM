%  DEMOSPECRET2 - Light scattering of metallic nanodisk.
%    For a metallic nanodisk and an incoming plane wave, this program
%    computes the scattering cross section for different light wavelengths
%    using the full Maxwell equations, and compares the results with those
%    obtained within the quasistatic approximation.
%
%  Runtime on my computer:  18 sec.

%%  initialization
%  options for BEM simulation
op1 = bemoptions( 'sim', 'stat', 'interp', 'curv' );
op2 = bemoptions( 'sim', 'ret',  'interp', 'curv' );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };

%  polygon for disk
poly = polygon( 25, 'size', [ 30, 30 ] );
%  edge profile for nanodisk
edge = edgeprofile( 5, 11 );
%  extrude polygon to nanoparticle
p = tripolygon( poly, edge );
%  initialize sphere
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op1 );

%%  BEM simulation
%  set up BEM solvers
bem1 = bemsolver( p, op1 );
bem2 = bemsolver( p, op2 );

%  plane wave excitation
exc1 = planewave( [ 1, 0, 0; 0, 1, 0 ], [ 0, 0, 1; 0, 0, 1 ], op1 );
exc2 = planewave( [ 1, 0, 0; 0, 1, 0 ], [ 0, 0, 1; 0, 0, 1 ], op2 );
%  light wavelength in vacuum
enei = linspace( 450, 750, 40 );
%  allocate scattering cross sections
sca1 = zeros( length( enei ), 2 );
sca2 = zeros( length( enei ), 2 );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charge
  sig1 = bem1 \ exc1( p, enei( ien ) );
  sig2 = bem2 \ exc2( p, enei( ien ) );
  %  scattering cross sections
  sca1( ien, : ) = exc1.sca( sig1 );
  sca2( ien, : ) = exc2.sca( sig2 );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( enei, sca1, 'o--' );  hold on;
if ~verLessThan( 'matlab', '8.4.0' ), set(gca, 'ColorOrderIndex', 1 );  end
plot( enei, sca2, 's-'  );  

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section (nm^2)' );

legend( 'x-pol, stat', 'y-pol, stat', 'x-pol, ret', 'y-pol, ret' );
