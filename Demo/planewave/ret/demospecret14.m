%  DEMOSPECRET14 - Spectra for metallic nanodisk on top of substrate.
%    We consider a metallic nanodisk with a diameter of 60 nm and a height
%    of 10 nm, which is attached to a substrate.  We compare scattering
%    spectra for the situations where the lower plate is either
%    slightly above or below the substrate, demonstrating that both
%    simulations give approximately the same results.  As we need a refined
%    surface discretization of the nanodisk, the demo program takes rather
%    long.
%
%  Runtime on my computer:  15 minutes.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 4 ) };
%  location of interface of substrate
ztab = 0;

%  options for layer structure
op = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, op );
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv', 'layer', layer );

%  polygon for disk
%    to obtain agreement between the two simulations we need a sufficiently
%    fine surface discretization, unfortunately this slows down the
%    simulation
poly = polygon( 30, 'size', [ 60, 60 ] );
%  edge profile for nanodisk
%    MODE '01' produces a rounded edge on top and a sharp edge on bottom,
%    MIN controls the lower z-value of the nanoparticle 
edge = edgeprofile( 10, 11, 'mode', '01', 'min', 1e-2 );
%  extrude polygon to nanoparticle
p = tripolygon( poly, edge );

%  we now split the particle into an upper part and a lower plate
[ pup, plo ] = select( p, 'carfun', @( x, y, z ) z >= 2e-2 );
%  the lower plate is finally shifted to slightly below the substrate
plo = shift( plo, [ 0, 0, - 2e-2 ] );

%  set up COMPARTICLE objects
p1 = comparticle( epstab, { p }, [ 2, 1 ], 1, op );
p2 = comparticle( epstab, { pup, plo }, [ 2, 1; 2, 3 ], [ 1, 2 ], op );

%  light propagation angles
theta = pi / 180 * reshape( linspace( 0, 80, 5 ), [], 1 );
%  TM mode, excitation from above
dir = [ sin( theta ), 0 * theta, - cos( theta ) ];
pol = [ cos( theta ), 0 * theta,   sin( theta ) ];
%  light wavelength in vacuum
enei = linspace( 600, 800, 20 );

%%  tabulated Green functions
%  For the retarded simulation we first have to set up a table for the
%  calculation of the reflected Green function.  This part is usually slow
%  and we thus compute GREENTAB only if it has not been computed before.
if ~exist( 'greentab', 'var' ) || ~greentab.ismember( layer, enei, p2 )
  %  automatic grid for tabulation
  tab = tabspace( layer, p2, 'nz', [ 30, 2 ] );
  %  Green function table
  greentab = compgreentablayer( layer, tab );
  %  precompute Green function table
  %    for a more accurate simulation of the layer the number of
  %    wavelenghts should be increased
  greentab = set( greentab, linspace( 600, 800, 5 ), op );
end
%  add table of Green functions to options
op.greentab = greentab;

%%  BEM simulation    
%  set up BEM solvers
bem1 = bemsolver( p1, op );
bem2 = bemsolver( p2, op );

%  plane wave excitation
exc = planewave( pol, dir, op );
%  allocate scattering cross sections
sca1 = zeros( length( enei ), size( pol, 1 ) );
sca2 = zeros( length( enei ), size( pol, 1 ) );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charges
  sig1 = bem1 \ exc( p1, enei( ien ) );
  sig2 = bem2 \ exc( p2, enei( ien ) );
  %  scattering cross sections
  sca1( ien, : ) = exc.sca( sig1 );
  sca2( ien, : ) = exc.sca( sig2 );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );
  
%%  final plot
plot( enei, sca1, 'o-'  );  hold on
if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
plot( enei, sca2, 's--' );  

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section' );

legend( '0^o, p1', '20^o', '40^o', '60^o', '80^o', '0^o, p2' );
