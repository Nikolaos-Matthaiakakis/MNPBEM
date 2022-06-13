%  DEMOSPECRET8 - Scattering spectra for metallic nanodisk on substrate.
%    For a metallic nanodisk with a diameter of 60 nm located on top of a
%    substrate and an incoming plane wave, with TM polarization and
%    different excitation angles, this program computes the scattering
%    spectrum using the full Maxwell equations.
%
%  Runtime on my computer:  65 sec.

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
op = bemoptions( 'sim', 'ret',  'interp', 'curv' , 'layer', layer );

%  polygon for disk
poly = polygon( 25, 'size', [ 60, 60 ] );
%  edge profile for nanodisk
%    MODE '01' produces a rounded edge on top and a sharp edge on bottom,
%    MIN controls the lower z-value of the nanoparticle 
edge = edgeprofile( 10, 11, 'mode', '01', 'min', 1e-3 );
%  extrude polygon to nanoparticle
p = tripolygon( poly, edge );

%  set up COMPARTICLE objects
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

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
  %  automatic grid for tabulation
  %    we use a rather small number NZ for tabulation to speed up the
  %    simulations
  tab = tabspace( layer, p, 'nz', 5 );
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
