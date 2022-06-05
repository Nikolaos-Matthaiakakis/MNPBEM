%  DEMOSPECSTAT12 - Light scattering of nanodisk above substrate.
%    For a metallic nanodisk located on top of a substrate and an incoming
%    plane wave with TM polarization and varying excitation angle, this
%    program computes the scattering cross sections for different light
%    wavelengths within the quasistatic approximation.
%
%  Runtime on my computer:  8 sec.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 4 ) };
%  location of interface of substrate
ztab = 0;

%  default options for layer structure
op = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, op );
%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' , 'layer', layer );

%  polygon for disk
poly = polygon( 25, 'size', [ 30, 30 ] );
%  edge profile for nanodisk
%    MODE '01' produces a rounded edge on top and a sharp edge on bottom,
%    MIN controls the lower z-value of the nanoparticle 
edge = edgeprofile( 5, 11, 'mode', '01', 'min', 1e-3 );
%  extrude polygon to nanoparticle
p = tripolygon( poly, edge );

%  set up COMPARTICLE objects
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%  light propagation angles
theta = pi / 180 * reshape( linspace( 0, 80, 5 ), [], 1 );
%  TM mode, excitation from above
dir = [ sin( theta ), 0 * theta, - cos( theta ) ];
pol = [ cos( theta ), 0 * theta,   sin( theta ) ];

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );

%  plane wave excitation
exc = planewave( pol, dir, op );
%  light wavelength in vacuum
enei = linspace( 550, 750, 40 );
%  allocate scattering and extinction cross sections
sca = zeros( length( enei ), size( pol, 1 ) );

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

legend( '0^o', '20^o', '40^o', '60^o', '80^o' )
