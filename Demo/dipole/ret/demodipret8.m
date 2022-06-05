%  DEMODIPRET8 - Lifetime reduction for dipole between sphere and layer.
%    For a metallic nanosphere with a diameter of 4 nm located 1 nm above a
%    substrate and a dipole located between sphere and layer, this program
%    computes the total dipole scattering rates using the full Maxwell
%    equations, and compares the results with those obtained within the
%    quasistatic approximation.
%
%  Runtime on my computer:  24 sec.

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
op1 = bemoptions( 'sim', 'stat', 'interp', 'curv' , 'layer', layer );
op2 = bemoptions( 'sim', 'ret',  'interp', 'curv' , 'layer', layer );

%  nanosphere with finer discretization at the bottom
p = flip( trispheresegment( 2 * pi * linspace( 0, 1, 31 ),  ...
                                pi * linspace( 0, 1, 31 ) .^ 2, 4 ), 3 );
%  place nanosphere 1 nm above substrate
p = shift( p, [ 0, 0, - min( p.pos( :, 3 ) ) + 1 + ztab ] ); 

%  set up COMPARTICLE object
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op1 );

%%  dipole oscillator
enei = 550;
%  positions of dipole
x = reshape( linspace( 0, 5, 51 ), [], 1 );
%  compoint
pt = compoint( p, [ x, 0 * x, 0 * x + 0.5 ], op1 );
%  we need GREENTAB for the initialization of the dipole object, so we next
%  proceed with the tabulated Green function

%  tabulated Green functions
%    For the retarded simulation we first have to set up a table for the
%    calculation of the reflected Green function.  This part is usually
%    slow and we thus compute GREENTAB only if it has not been computed
%    before.
if ~exist( 'greentab', 'var' ) || ~greentab.ismember( layer, enei, { p, pt } )
  %  automatic grid for tabulation
  %    we use a rather small number NZ for tabulation to speed up the
  %    simulations
  tab = tabspace( layer, { p, pt }, 'nz', 5 );
  %  Green function table
  greentab = compgreentablayer( layer, tab );
  %  precompute Green function table
  greentab = set( greentab, enei, op2, 'waitbar', 0 );
end
op2.greentab = greentab;

%  dipole excitation
dip1 = dipole( pt, [ 1, 0, 0; 0, 0, 1 ], op1 );
dip2 = dipole( pt, [ 1, 0, 0; 0, 0, 1 ], op2 );

%%  BEM simulation
%  set up BEM solvers
bem1 = bemsolver( p, op1 );
bem2 = bemsolver( p, op2 );
%  surface charge
sig1 = bem1 \ dip1( p, enei );
sig2 = bem2 \ dip2( p, enei );
%  total and radiative decay rate
[ tot1, rad1 ] = dip1.decayrate( sig1 );
[ tot2, rad2 ] = dip2.decayrate( sig2 );

%%  final plot
plot( x, tot1, 'o-' );  hold on;
if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
plot( x, tot2, '.-' );

xlabel( 'Position (nm)' );
ylabel( 'Total decay rate' );

legend( 'x-dip (qs)', 'z-dip (qs)', 'x-dip (ret)', 'z-dip (ret)' );
