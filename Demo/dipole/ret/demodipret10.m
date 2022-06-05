%  DEMODIPRET10 - Photonic LDOS for nanodisk above layer.
%    For a silver nanodisk with a diameter of 30 nm and a height of 5 nm,
%    and a dipole oscillator with dipole orientation along x and z and
%    located 5 nm away from the disk and 0.5 nm above the substrate, this
%    program computes the lifetime reduction (photonic LDOS) as a function
%    of transition dipole energies, using the full Maxwell equations.
%
%  Runtime on my computer:  7 min.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'silver.dat' ), epsconst( 4 ) };
%  location of interface of substrate
ztab = 0;

%  default options for layer structure
opt = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, opt );
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv' , 'layer', layer );

%  polygon for disk
poly = polygon( 25, 'size', [ 30, 30 ] );
%  edge profile for nanodisk
%    MODE '01' produces a rounded edge on top and a sharp edge on bottom,
%    MIN controls the lower z-value of the nanoparticle 
edge = edgeprofile( 5, 11, 'mode', '01', 'min', 1e-3 );
%  use finer discretization at (R,0,0)
refun = @( pos, d ) 0.5 + abs( 15 - pos( :, 1 ) );
%  extrude polygon to nanoparticle
p = tripolygon( poly, edge, 'refun', refun );

%  set up COMPARTICLE object
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%%  dipole oscillator
enei = linspace( 300, 700, 40 );
%  positions of dipole
x = max( p.pos( :, 1 ) ) + 2;
%  compoint
pt = compoint( p, [ x, 0 * x, 0 * x + 0.5 ], op );
%  we need GREENTAB for the initialization of the dipole object, so we next
%  proceed with the tabulated Green function

%  tabulated Green functions
%    For the retarded simulation we first have to set up a table for the
%    calculation of the reflected Green function.  This part is usually
%    slow and we thus compute GREENTAB only if it has not been computed
%    before.
if ~exist( 'greentab', 'var' ) || ~greentab.ismember( layer, enei, p, pt )
  %  automatic grid for tabulation
  %    we use a rather small number NZ for tabulation to speed up the
  %    simulations
  tab = tabspace( layer, p, pt, 'nz', 5 );
  %  Green function table
  greentab = compgreentablayer( layer, tab );
  %  precompute Green function table
  %    for a more accurate simulation of the layer the number of
  %    wavelenghts should be increased  
  greentab = set( greentab, linspace( 300, 800, 5 ), op );
end
op.greentab = greentab;

%  dipole excitation
dip = dipole( pt, [ 1, 0, 0; 0, 0, 1 ], op );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );
%  initialize total and radiative scattering rate
[ tot, rad ] = deal( zeros( numel( enei ), 2 ) );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charge
  sig = bem \ dip( p, enei( ien ) );
  %  total and radiative decay rate
  [ tot( ien, : ), rad( ien, : ) ] = dip.decayrate( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( enei, tot, '.-'  ); 

xlabel( 'Wavelength (nm)' );
ylabel( 'Total decay rate' );

legend( 'x-dip', 'z-dip' );
