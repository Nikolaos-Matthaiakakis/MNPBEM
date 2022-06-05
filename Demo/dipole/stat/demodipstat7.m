%  DEMODIPSTAT7 - Photonic LDOS for nanodisk above layer.
%    For a silver nanodisk with a diameter of 30 nm and a height of 5 nm,
%    and a dipole oscillator with dipole orientation along x and z and
%    located 5 nm away from the disk and 0.5 nm above the substrate, this
%    program computes the lifetime reduction (photonic LDOS) as a function
%    of transition dipole energies, using the quasistatic approximation.
%
%  Runtime on my computer:  36 sec.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'silver.dat' ), epsconst( 4 ) };
%  location of interface of substrate
ztab = 0;

%  default options for layer structure
op = layerstructure.options; 
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, op );
%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' , 'layer', layer );

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
%  dipole excitation
dip = dipole( pt, [ 1, 0, 0; 0, 0, 1 ], op );

%  initialize total and radiative scattering rate
[ tot, rad ] = deal( zeros( numel( enei ), 2 ) );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );

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
