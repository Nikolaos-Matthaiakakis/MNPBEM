%  DEMOSPECRET20 - Nanorod above substrate using itertive BEM solver.
%    For a metallic nanorod located above a substrate and an incoming plane
%    wave, with TM polarization and different excitation angles, this
%    program computes the scattering cross section for different light
%    wavelengths and for the full Maxwell equations using an itertive BEM
%    solver.
%
%  Runtime on my computer: 2 hours.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 2.25 ) };
%  location of interface of substrate
ztab = 0;

%  default options for layer structure
op = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, op );
%  options for BEM simulations
op = bemoptions( 'sim', 'ret', 'interp', 'curv' , 'layer', layer );
%  use iterative BEM solver
%    Output flag controls information about number of iterations and timing
%    of matrix evaluations.  For comparison you might also like to run the
%    program w/o iterative solvers by commenting the next line.
op.iter = bemiter.options( 'output', 1 );

%  initialize nanorod
%    diameter 20 nm, length 800 nm, number of boundary elements 7378 
p = trirod( 20, 800, [ 15, 15, 500 ] );
%  shift nanorod 10 nm above layer
p = shift( p, [ 0, 0, - min( p.pos( :, 3 ) ) + 10 + ztab ] ); 

%  set up COMPARTICLE object
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%  light propagation angles
theta = pi / 180 * reshape( linspace( 0, 80, 5 ), [], 1 );
%  TM mode, excitation from above
dir = [ sin( theta ), 0 * theta, - cos( theta ) ];
pol = [ cos( theta ), 0 * theta,   sin( theta ) ];
%  photon wavelength
enei = linspace( 450, 1000, 20 );

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
  greentab = set( greentab, linspace( min( enei ), max( enei ), 10 ), op );
end
op.greentab = greentab;

%%  BEM solver
%  initialize BEM solver
bem = bemsolver( p, op );
%  initialize plane wave excitations
exc = planewave( pol, dir, op );
%  scattering cross sections
sca = zeros( numel( enei ), size( dir, 1 ) );

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
plot( enei, sca, 'o-' );  

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section (nm^2)' );

legend( '0^o, qs', '20^o', '40^o', '60^o', '80^o', '0^o, ret' );

title( 'TM polarization, excitation from above' );
