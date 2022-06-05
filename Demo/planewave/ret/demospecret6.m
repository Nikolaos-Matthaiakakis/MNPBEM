%  DEMOSPECRET6 - Light scattering of metallic nanosphere above substrate.
%    For a metallic nanosphere with a diameter of 4 nm located 1 nm above a
%    substrate and an incoming plane wave, with TM polarization and
%    different excitation angles, this program computes the scattering
%    cross section for different light wavelengths and for the full Maxwell
%    equations, and compares the results with those obtained within the
%    quasistatic approximation.
%
%  Runtime on my computer:  36 sec.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 4 ) };
%  location of interface of substrate
ztab = 0;

%  default options for layer structure
op = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, op );
%  options for BEM simulations
op1 = bemoptions( 'sim', 'stat', 'interp', 'curv' , 'layer', layer );
op2 = bemoptions( 'sim', 'ret',  'interp', 'curv' , 'layer', layer );

%  initialize nanosphere
p = trisphere( 144, 4 );
%  shift nanosphere 1 nm above layer
p = shift( p, [ 0, 0, - min( p.pos( :, 3 ) ) + 1 + ztab ] ); 

%  set up COMPARTICLE object
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%  light propagation angles
theta = pi / 180 * reshape( linspace( 0, 80, 5 ), [], 1 );
%  TM mode, excitation from above
dir = [ sin( theta ), 0 * theta, - cos( theta ) ];
pol = [ cos( theta ), 0 * theta,   sin( theta ) ];
%  photon wavelength
enei = linspace( 450, 750, 20 );

%%  tabulated Green functions
%  For the retarded simulation we first have to set up a table for the
%  calculation of the reflected Green function.  This part is usually slow
%  and we thus compute GREENTAB only if it has not been computed before.
if ~exist( 'greentab', 'var' ) || ~greentab.ismember( layer, enei, p )
  %  automatic grid for tabulation
  tab = tabspace( layer, p );
  %  Green function table
  greentab = compgreentablayer( layer, tab );
  %  precompute Green function table
  %    for a more accurate simulation of the layer the number of
  %    wavelenghts should be increased
  greentab = set( greentab, linspace( 350, 800, 5 ), op2 );
end
op2.greentab = greentab;

%%  BEM solver
%  initialize BEM solvers
bem1 = bemsolver( p, op1 );
bem2 = bemsolver( p, op2 );
%  initialize plane wave excitations
exc1 = planewave( pol, dir, op1 );
exc2 = planewave( pol, dir, op2 );
%  scattering cross sections
sca1 = zeros( numel( enei ), size( dir, 1 ) );
sca2 = zeros( numel( enei ), size( dir, 1 ) );


multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charges
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
if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
plot( enei, sca2, 's-'  ); 

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section (nm^2)' );

legend( '0^o, qs', '20^o', '40^o', '60^o', '80^o', '0^o, ret' );

title( 'TM polarization, excitation from above' );
