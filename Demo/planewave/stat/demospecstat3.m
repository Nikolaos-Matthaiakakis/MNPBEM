%  DEMOSPECSTAT3 - Light scattering of coated metallic sphere.
%    We consider a glass sphere with a diameter of 10 nm coated by a 2 nm
%    thick silver layer.  For an incoming plane wave, this program computes
%    the scattering cross section for different light wavelengths and for
%    two different sphere discretizations within the quasistatic
%    approximation.
%
%  Runtime on my computer:  16.3 sec.

%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' );
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'silver.dat' ), epsconst( 2.25 ) };

%  diameter of sphere
diameter = [ 10, 12 ];
%  initialize spheres
p1 = trisphere( 144, 1 );
p2 = trisphere( 256, 1 );
%  set up COMPARTICLE objects
p1 = comparticle( epstab, { scale( p1, diameter( 1 ) ),  ...
                            scale( p1, diameter( 2 ) ) }, [ 3, 2; 2, 1 ], 1, 2, op );
p2 = comparticle( epstab, { scale( p2, diameter( 1 ) ),  ...
                            scale( p2, diameter( 2 ) ) }, [ 3, 2; 2, 1 ], 1, 2, op );                          

%%  BEM simulation
%  set up BEM solvers
bem1 = bemsolver( p1, op );
bem2 = bemsolver( p2, op );

%  plane wave excitation
exc = planewave( [ 1, 0, 0 ], [ 0, 0, 1 ], op );
%  light wavelength in vacuum
enei = linspace( 450, 600, 40 );
%  allocate scattering and extinction cross sections
sca = zeros( length( enei ), 2 );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charge
  sig1 = bem1 \ exc( p1, enei( ien ) );
  sig2 = bem2 \ exc( p2, enei( ien ) );
  %  scattering cross sections
  sca( ien, 1 ) = exc.sca( sig1 );
  sca( ien, 2 ) = exc.sca( sig2 );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( enei, sca, 'o-'  );  hold on;

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section (nm^2)' );

legend( '144 vertices', '256 vertices' );
