%  DEMODIPSTAT10 - Photonic LDOS for nanodisk using mirror symmetry.
%    For a silver nanodisk with a diameter of 30 nm and a height of 5 nm,
%    and a dipole oscillator with dipole orientation along x and z and
%    located 5 nm away from the disk, this program computes the lifetime
%    reduction (photonic LDOS) as a function of transition dipole energies,
%    using the quasistatic approximation and mirror symmetry.
%
%  Runtime on my computer:  16 sec.

%%  initialization
%  options for BEM simulation, set SYM keyword
op = bemoptions( 'sim', 'stat', 'interp', 'curv' , 'sym', 'xy' );

%  polygon for disk
poly = polygon( 25, 'size', [ 30, 30 ] );
%  edge profile for nanodisk
%    MODE '01' produces a rounded edge on top and a sharp edge on bottom,
%    MIN controls the lower z-value of the nanoparticle 
edge = edgeprofile( 5, 11, 'mode', '01', 'min', 1e-3 );
%  use finer discretization at (R,0,0)
refun = @( pos, d ) 0.5 + 0.8 * abs( 14 - pos( :, 1 ) );
%  extrude polygon to nanoparticle
p = tripolygon( poly, edge, op, 'refun', refun );

%  set up COMPARTICLEMIRROR object
p = comparticlemirror( epstab, { p }, [ 2, 1 ], 1, op );

%%  dipole oscillator
enei = linspace( 400, 800, 40 );
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
