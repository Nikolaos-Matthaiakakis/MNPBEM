%  DEMOSPECSTAT2 - Light scattering of metallic nanoellipsoid.
%    For a metallic nanoellipsoid and an incoming plane wave with a
%    polarization along the long rod axis, this program computes the
%    scattering cross section for different light wavelengths and different
%    axis ratios within the quasistatic approximation, and compares the
%    results with Mie-Gans theory.
%
%  Runtime on my computer:  3.5 sec.

%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'waitbar', 0 );
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };

%  light wavelength in vacuum
enei = linspace( 500, 750, 40 );
%  axes of ellipsoids
ax = [ 10, 10, 20;  10, 10, 30;  10, 10, 40 ];

%  allocate scattering and extinction cross sections
[ sca, sca0 ] = deal( zeros( length( enei ), size( ax, 1 ) ) );
[ ext, ext0 ] = deal( zeros( length( enei ), size( ax, 1 ) ) );

%  loop over different ellipsoids
for i = 1 : size( ax, 1 )
  
  %  nano ellipsoid
  p = scale( trisphere( 144, 1 ), ax( i, : ) );
  %  set up COMPARTICLE object
  p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

  %  set up BEM solver
  bem = bemsolver( p, op );
  %  plane wave excitation
  exc = planewave( [ 0, 0, 1 ], [ 1, 0, 0 ], op );

  %  loop over wavelengths
  for ien = 1 : length( enei )
    %  surface charge
    sig = bem \ exc( p, enei( ien ) );
    %  scattering and extinction cross sections
    sca( ien, i ) = exc.sca( sig );
    ext( ien, i ) = exc.ext( sig );
  end
  
  %  set up Mie Gans solver
  mie = miegans( epstab{ 2 }, epstab{ 1 }, ax( i, : ) );
  %  scattering and extinction cross sections
  sca0( :, i ) = mie.sca( enei, [ 0, 0, 1 ] );
  ext0( :, i ) = mie.ext( enei, [ 0, 0, 1 ] );
end

%  final plot
plot( enei, sca,  'o-' );  hold on;
if ~verLessThan( 'matlab', '8.4.0' ), set(gca, 'ColorOrderIndex', 1 );  end
plot( enei, sca0, '+'  );  

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section (nm^2)' );

legend( 'BEM 1:1:2', 'BEM 1:1:3', 'BEM 1:1:4',  ...
        'Mie-Gans 1:1:2', 'Mie-Gans 1:1:3', 'Mie-Gans 1:1:4', 2 );
