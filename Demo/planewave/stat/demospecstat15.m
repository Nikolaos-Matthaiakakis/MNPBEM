%  DEMOSPECSTAT15 - Light scattering of nanodisk with mirror symmetry.
%    For a metallic nanodisk and an incoming plane wave with a
%    polarization along x and y, this program computes the scattering cross
%    sections for different light wavelengths within the quasistatic
%    approximation.  The simulations are performed with and without the use
%    of mirror symmetry, and the runtimes and results of the two approaches
%    are compared.
%
%  Runtime on my computer:  30 sec.

%  options for BEM simulation with and w/o mirror symmetry
op1 = bemoptions( 'sim', 'stat', 'interp', 'curv', 'sym', 'xy', 'waitbar', 0 );
op2 = rmfield( op1, 'sym' );
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };

%  polygon for triangle
poly = polygon( 30, 'size', [ 30, 30 ] );
%  edge profile for triangle
edge = edgeprofile( 5, 11 );
%  extrude polygon to nanoparticle 
%    the OP structure ensures that the extruded polygon has the right
%    symmetry
p = tripolygon( poly, edge, op1 );

%  set up COMPARTICLE objects
p = comparticlemirror( epstab, { p }, [ 2, 1 ], 1, op1 );
%  full particle
pfull = full( p );

%%  excitation and allocation of scattering cross sections
%  plane wave excitations
exc1 = planewave( [ 1, 0, 0; 0, 1, 0 ], [ 0, 0, 1; 0, 0, 1 ], op1 );
exc2 = planewave( [ 1, 0, 0; 0, 1, 0 ], [ 0, 0, 1; 0, 0, 1 ], op2 );
%  number of wavelengths
n = 40;
%  light wavelength in vacuum
enei = linspace( 500, 750, n );
%  allocate scattering cross sections
sca1 = zeros( n, 2 );
sca2 = zeros( n, 2 );

%%  BEM simulation with mirror symmetry
tic;
%  set up BEM solver
bem1 = bemsolver( p, op1 );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charge
  sig1 = bem1 \ exc1( p, enei( ien ) );
  %  scattering cross sections
  sca1( ien, : ) = exc1.sca( sig1 );
  
  multiWaitbar( 'BEM solver', ien / ( 2 * n ) );
end
%  end timer
fprintf( 1, 'CPU time bemstatmirror: %8.2f\n', toc );

%%  BEM simulation w/o symmetry
id = tic;
%  set up BEM solver
bem2 = bemsolver( pfull, op2 );

%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charge
  sig2 = bem2 \ exc2( pfull, enei( ien ) );
  %  scattering cross sections
  sca2( ien, : ) = exc2.sca( sig2 );
  
  multiWaitbar( 'BEM solver', ( ien + n ) / ( 2 * n ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%  end timer
fprintf( 1, 'CPU time bemstat:       %8.2f\n', toc );

%%  final plot
plot( enei, sca1, 'o-'   );  hold on;
if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
plot( enei, sca2, 's--'  ); 

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section (nm^2)' );

legend( 'x-pol, with mirror', 'y-pol, with mirror',  ...
        'x-pol, w/o mirror',  'y-pol, w/o mirror' );
