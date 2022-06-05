%  DEMOSPECRET13 - Spectra for metallic nanodisk approaching substrate.
%    We consider a metallic nanodisk with a diameter of 60 nm and a height
%    of 10 nm, which approaches the substrate and is finally attached to
%    it.  For different particle-substrate separations the spectra are
%    computed.  This demo file shows that for a nanoparticle attached to
%    the substrate the number of integration points can be chosen
%    significantly smaller than for small (non-vanishing) separations.  As
%    several simulations are performed, the demo program takes rather long.
%
%  Runtime on my computer:  7.5 minutes.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 4 ) };
%  location of interface of substrate
ztab = 0;

%  options for layer structure
%    ZTOL controls the distance for which particle boundaries are
%    interpreted as being attached to the layer
op = layerstructure.options( 'ztol', 1e-2 ); 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, op );
%  options for BEM simulation
%    through REFINE we choose a higher number of integration points per
%    boundary element
op = bemoptions( 'sim', 'ret', 'interp', 'curv', 'layer', layer, 'refine', 2 );

%  polygon for disk
poly = polygon( 25, 'size', [ 60, 60 ] );
%  edge profile for nanodisk
%    MODE '01' produces a rounded edge on top and a sharp edge on bottom,
%    MIN controls the lower z-value of the nanoparticle 
edge = edgeprofile( 10, 11, 'mode', '01', 'min', 0 );
%  extrude polygon to nanoparticle
p1 = tripolygon( poly, edge );

%  distance of the disk to the substrate
%    For the last value the distance is smaller than ZTOL and the disk is
%    interpreted as being attached to the substrate
d = [ 10, 1, 0.5, 0.1, 1e-3 ];
%  number of integration points for diagonal Green function elements
%    this number should be sufficiently high for boundary elements that are
%    close (but not touching) the boundary, see also
%    plot( quadface( 'npol', 10 ) ) 
npol = [ 10, 20, 30, 40, 10 ];

%  light propagation angles
theta = pi / 180 * reshape( 40, [], 1 );
%  TM mode, excitation from above
dir = [ sin( theta ), 0 * theta, - cos( theta ) ];
pol = [ cos( theta ), 0 * theta,   sin( theta ) ];
%  plane wave excitation
exc = planewave( pol, dir, op );

%  photon wavelength
enei = linspace( 550, 800, 20 );
%  allocate output array
sca = zeros( numel( enei ), numel( d ) );

%%  tabulated Green functions
%  For the retarded simulation we first have to set up a table for the
%  calculation of the reflected Green function.  
  
%  we set up a Green function table with given limits
tab = tabspace( layer, [ 0, 80, 31 ], [ 1e-3, 50, 10 ], 1e-10 );
%  Green function table
greentab = compgreentablayer( layer, tab );
%  precompute Green function table
%    for a more accurate simulation of the layer the number of
%    wavelenghts should be increased
greentab = set( greentab, linspace( 350, 800, 5 ), op );
%  add table of Green functions to options
op.greentab = greentab;


%%  BEM simulation    

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over distances
for i = 1 : numel( d )  
  %  set up COMPARTICLE object
  %    shift particle vertically and use different NPOL values
  p = comparticle( epstab, { shift( p1, [ 0, 0, d( i ) ] ) },  ...
                                        [ 2, 1 ], 1, op, 'npol', npol( i ) );
  %  set up BEM solver
  bem = bemsolver( p, op, 'waitbar', 0 );
  
  %  loop over wavelengths
  for ien = 1 : length( enei )
    %  surface charge
    sig = bem \ exc( p, enei( ien ) );
    %  scattering cross sections
    sca( ien, i ) = exc.sca( sig );
  end
  
  multiWaitbar( 'BEM solver',  i / numel( d ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );
  
%%  final plot
plot( enei, sca, 'o-' );

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section' );

legend( '10 nm', '1 nm', '0.5 nm', '0.1 nm', 'on subs', 2 );
