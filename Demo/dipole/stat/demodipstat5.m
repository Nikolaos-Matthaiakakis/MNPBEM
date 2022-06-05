%  DEMODIPSTAT5 - Lifetime reduction for dipole between sphere and layer.
%    For a metallic nanosphere with a diameter of 4 nm located 1 nm above a
%    substrate and a dipole located between sphere and layer, this program
%    computes the total dipole scattering rates within the quasistatic
%    approximation.
%
%  Runtime on my computer:  7.5 sec.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 2.25 ) }; 
%  location of interface of substrate
ztab = 0;

%  default options for layer structure
opt = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, opt );
%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' , 'layer', layer );

%  nanosphere with finer discretization at the bottom
p = flip( trispheresegment( 2 * pi * linspace( 0, 1, 31 ),  ...
                                pi * linspace( 0, 1, 31 ) .^ 2, 4 ), 3 );
%  place nanosphere 1 nm above substrate
p = shift( p, [ 0, 0, - min( p.pos( :, 3 ) ) + 1 + ztab ] ); 

%  set up COMPARTICLE object
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%%  dipole oscillator
enei = 550;
%  positions of dipole
x = reshape( linspace( 0, 5, 51 ), [], 1 );
%  compoint
pt = compoint( p, [ x, 0 * x, 0 * x + 0.5 ], op );
%  dipole excitation
dip = dipole( pt, [ 1, 0, 0; 0, 0, 1 ], op );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );
%  surface charge
sig = bem \ dip( p, enei );
%  total and radiative decay rate
[ tot, rad ] = dip.decayrate( sig );

%%  final plot
plot( x, tot, '-'  );  hold on;

xlabel( 'Position (nm)' );
ylabel( 'Total decay rate' );

legend( 'x-dip', 'z-dip' );
