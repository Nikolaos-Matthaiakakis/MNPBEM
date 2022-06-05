%  DEMOSPECSTAT8 - Light scattering of coupled nanotriangles (bowtie).
%    For two coupled metallic nanotriangles (bowtie geometry) and an
%    incoming plane wave with a polarization along x and y, this program
%    computes the scattering cross sections for different light wavelengths
%    within the quasistatic approximation.
%
%  Runtime on my computer:  8.9 sec.

%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' );
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epstable( 'gold.dat' ) };

%  polygon for triangle
poly = round( polygon( 3, 'size', [ 30,  2 / sqrt( 3 ) * 30 ] ) );
%  edge profile for triangle
edge = edgeprofile( 5, 11 );
%  extrude polygon to nanoparticle
p1 = tripolygon( poly, edge );
%  shift polygon
p1 = shift( p1, [ - min( p1.pos( :, 1 ) ) + 2, 0, 0 ] );
%  flip second polygon
p2 = flip( p1, 1 );

%  set up COMPARTICLE object
p = comparticle( epstab, { p1, p2 }, [ 2, 1; 3, 1 ], 1, 2, op );

%%  BEM simulation
%  set up BEM solver
%    to speed up the simulation, we use an eigenmode expansion with 20
%    eigenmodes
bem = bemsolver( p, op, 'nev', 20 );

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
