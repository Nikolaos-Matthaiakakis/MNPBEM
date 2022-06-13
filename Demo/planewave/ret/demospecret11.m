%  DEMOSPECRET11 - Scattering spectra for two nanospheres in layer.
%    For two metallic nanospheres with a diameter of 8 nm and a 1 nm gap,
%    embedded inside a 10 nm thick glass layer on top of a substrate, and
%    an incoming plane wave, this program computes the scattering spectrum
%    using the full Maxwell equations.
%
%  Runtime on my computer:  2 min.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ),  ...
           epstable( 'gold.dat' ), epsconst( 2.5 ), epsconst( 10 ) };
%  location of interface of substrate
ztab = [ 10, 0 ];

%  default options for layer structure
op = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 4, 5 ], ztab, op );
%  options for BEM simulations
op = bemoptions( 'sim', 'ret',  'interp', 'curv' , 'layer', layer );

%  radius of spheres
a = 4;
%  extrude polygon to nanoparticle
p1 = shift( trisphere( 144, 2 * a ), [   a + 0.5, 0, a + 1 ] );
p2 = shift( trisphere( 144, 2 * a ), [ - a - 0.5, 0, a + 1 ] );

%  set up COMPARTICLE objects
p = comparticle( epstab, { p1, p2 }, [ 2, 4; 3, 4  ], 1, 2, op );

%  light propagation angles
theta = pi / 180 * reshape( linspace( 0, 80, 5 ), [], 1 );
%  TM mode, excitation from above
dir = [ sin( theta ), 0 * theta, - cos( theta ) ];
pol = [ cos( theta ), 0 * theta,   sin( theta ) ];
%  photon wavelengths
enei = linspace( 500, 800, 20 );

%%  tabulated Green functions
%  For the retarded simulation we first have to set up a table for the
%  calculation of the reflected Green function.  This part is usually slow
%  and we thus compute GREENTAB only if it has not been computed before.

if ~exist( 'greentab', 'var' ) || ~greentab.ismember( layer, enei, p )
  %  grid for tabulation
  %    we use a rather small number NZ for tabulation to speed up the
  %    simulation
  tab = tabspace( layer, p, 'nz', 10 );
  %  Green function table
  greentab = compgreentablayer( layer, tab );
  %  precompute Green function table
  %    for a more accurate simulation of the layer the number of
  %    wavelenghts should be increased
  greentab = set( greentab, linspace( 500, 800, 5 ), op );
end
op.greentab = greentab;

%%  BEM solver
%  initialize BEM solver
bem = bemsolver( p, op );
%  initialize plane wave excitation
exc = planewave( pol, dir, op );
%  scattering cross section
sca = zeros( numel( enei ), size( dir, 1 ) );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charges
  sig = bem \ exc( p, enei( ien ) );
  %  scattering cross section
  sca( ien, : ) = exc.sca( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( enei, sca, 'o-' );  hold on;

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section (nm^2)' );

legend( '0^o', '20^o', '40^o', '60^o', '80^o' );

title( 'TM polarization, excitation from above' );
