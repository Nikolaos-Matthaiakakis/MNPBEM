%  DEMOSPECSTAT10 - Light scattering of metallic nanosphere above substrate.
%    For a metallic nanosphere with a diameter of 4 nm located 1 nm above a
%    substrate and an incoming plane wave, with TM polarization and
%    different excitation angles, this program computes the scattering
%    cross section for different light wavelengths within the quasistatic
%    approximation.
%
%  Runtime on my computer:  4.4 sec.

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

%  initialize nanosphere
p = trisphere( 144, 4 );
%  shift nanosphere above substrate
p = shift( p, [ 0, 0, - min( p.pos( :, 3 ) ) + 1 + ztab ] ); 

%  set up COMPARTICLE objec
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%  light propagation angles
theta = pi / 180 * reshape( linspace( 0, 80, 5 ), [], 1 );
%  TM mode, excitation from above
dir = [ sin( theta ), 0 * theta, - cos( theta ) ];
pol = [ cos( theta ), 0 * theta,   sin( theta ) ];


%%  BEM solver
%  initialize BEM solver
bem = bemsolver( p, op );
%  initialize plane wave excitation
exc = planewave( pol, dir, op );

%  photon wavelength
enei = linspace( 450, 750, 40 );
%  scattering
csca = zeros( numel( enei ), size( dir, 1 ) );
cext = zeros( numel( enei ), size( dir, 1 ) );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charge
  sig = bem \ exc( p, enei( ien ) );
  %  scattering cross section
  csca( ien, : ) = exc.sca( sig );
  cext( ien, : ) = exc.ext( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( enei, csca, 'o-' );  hold on;

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section (nm^2)' );

legend( '0^o', '20^o', '40^o', '60^o', '80^o' )

title( 'TM polarization, excitation from above' );
