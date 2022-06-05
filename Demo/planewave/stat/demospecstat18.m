%  DEMOSPECSTAT18 - Auxiliary information for iterative BEM solver.
%    For the metallic nanorod of DEMOSPECSTAT17, we show how to obtain
%    auxiliary information about the iterative BEM solver.
%
%  Runtime on my computer:  30 sec.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'stat' );
%  use iterative BEM solver
%    output flag controls information about number of iterations
op.iter = bemiter.options( 'output', 1 );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };
%  nanorod
%    diameter 5 nm, length 300 nm, number of boundary elements 7378 
%    Note: For the given dimensions one should use a retarded BEM solver,
%    this demo file only shows the working principle of iterative solvers.
p = trirod( 5, 300, [ 15, 15, 500 ] );
%  initialize nanorod
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );

%  plane wave excitation
exc = planewave( [ 1, 0, 0; 0, 0, 1 ], [ 0, 0, 1; 1, 0, 0 ], op );
%  light wavelength in vacuum
%    for demonstration purposes we only use a single wavelength
enei = 800;  
ien = 1;

%  During the BEM evaluation Matlab keeps a copy of the BEM object.  In
%  case of restricted memory and when the BEM solver is called for several
%  wavelengths, it thus might be a good idea to clear all auxiliary
%  matrices in BEM before calling the initialization.
bem = clear( bem );
%  initialize BEM solver
bem = bem( enei( ien ) );
%  surface charge
[ sig, bem ] = solve( bem, exc( p, enei( ien ) ) );

%%  auxiliary information
%  print matrix compression and timing for H-matrix manipulation
hinfo( bem );
%  plot rank of low-rank matrices
plotrank( bem.F );
colorbar;
