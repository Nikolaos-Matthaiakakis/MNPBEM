%% Simulations with iterative BEM solvers
%
% Iterative BEM solvers use hierarchical matrices (in short H-matrices) for
% the compression of Green functions, together with iterative solvers
% (<matlab:doc('cgs') cgs>, <matlab:doc('bicgstab') bicgstab>, or
% <matlab:doc('gmres') gmres>) for the solution of the system of linear
% equations.  Simulations with the iterative BEM solvers can be
% sufficiently faster and less memory-consuming than simulations with the
% normal BEM solvers, in particular for nanoparticles consisting of several
% 1000 to 10000 boundary elements.  The speedup and memory reduction depend
% on the particle geometry and the chosen parameters.  At present our
% implementation is still somewhat experimental, and it is likely that
% future versions of the toolbox will benefit from further improvements.

%% Initialization

%  option structure
op = bemoptions( 'sim', 'ret' );
%  add options for iterative solver
op.iter = bemiter.options;
%  initialize BEM solver using COMPARTICLE object P
bem = bemsolver( p, op );

%%
% In comparison to normal BEM solvers one has to add the field |iter| to
% the options structure and run the simulations in the usual manner.  Users
% not interested in the implementation details might like to skip the rest
% of this section.  
%
%% Example
%
% Iterative BEM solvers should be used for nanoparticles consisting of
% several 1000 to 10000 boundary elements, and when computer time or memory
% become a serious limitation.  The following example shows the simulation
% for a gold nanorod consisting of 7378 boundary elements

%  options for BEM simulation
op = bemoptions( 'sim', 'ret' );
%  use iterative BEM solver
%    output flag controls information about number of iterations
%    comment the following line for switch off the iterative solver
op.iter = bemiter.options( 'output', 1 );
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };
%  initialize nanorod
p = trirod( 20, 800, [ 15, 15, 500 ] );
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%  set up BEM solver (display timing)
tic
bem = bemsolver( p, op );
%  plane wave excitation
exc = planewave( [ 1, 0, 0; 0, 0, 1 ], [ 0, 0, 1; 1, 0, 0 ], op );
%  surface charge for light wavelength of 800 nm
sig = bem \ exc( p, 800 );
toc

%%
% The above code takes 140 seconds for the iterative solver and 340 seconds
% for the normal BEM solver.
%
% Sometimes one is interested to obtain some additional information about
% the performance of the iterative solvers.  To this end, we provide an
% alternative calling sequence, which can be also used inside a loop over
% |enei|, together with the functions |hinfo| and |info|

%  During the BEM evaluation Matlab keeps a copy of the BEM object.  In
%  case of restricted memory and when the BEM solver is called for several
%  wavelengths, it thus might be a good idea to clear all auxiliary
%  matrices in BEM before calling the initialization.
bem = clear( bem );
%  initialize BEM solver
bem = bem( enei );
%  surface charge
[ sig, bem ] = solve( bem, exc( p, enei ) );

%  display matrix compression and timing for H-matrix manipulation
hinfo( bem );
%  display performance of iterative solver
info( bem )

%% Options
% The option structure contains the following fields

%  display default options for iterative solvers
bemiter.options

%%
%      solver: 'gmres'
%         tol: 1.0000e-06
%       maxit: 100
%     restart: []
%     precond: 'hmat'
%      output: 0
%       cleaf: 200
%        htol: 1.0000e-06
%        kmax: [4 100]
%     fadmiss: @(rad1,rad2,dist)2.5*min(rad1,rad2)<dist
%
% In general the default settings returned by |bemiter.options| should work
% perfectly for most problems of interest.  The meaning of the different
% fields, which can be also passed in form of property pairs to
% |bemiter.options|, is as follows
%
% * *|solver|* selects between the different iterative solvers
% <matlab:doc('cgs') cgs>, <matlab:doc('bicgstab') bicgstab>, and
% <matlab:doc('gmres') gmres> for the solution of the system of linear
% equations underlying our BEM approach.
% * *|tol|* selects the tolerance of the iterative solver.
% * *|maxit|* determines the maximum number of iterations.
% * *|restart|* is the number of restarts used by <matlab:doc('gmres')
% gmres>.
% * *|precond|* determines the preconditioner.  At present we recommend to
% not change the default setting |'hmat'|.
% * *|output|* turns on (1) or off (0) any intermediate output of the
% iterative BEM solver.
% * *|cleaf|* determines the minimum cluster size.
% * *|htol|* is the tolerance for the H-matrix compression.
% * *|kmax|* is the maximum rank for H-matrix compression.
% * *|fadmiss|* is a function for the admissibility criterion for cluster
% pairs.
%
%% MEX Compilation
%
% For the H-matrix manipulations we use MEX files.  The source code can be
% found in the directors |MNPBEM17/mex|.  There one also finds a file
% <matlab:edit('makemex') makemex> for compilation.  Although we provide
% pre-compiled versions for most operating systems, users with experience
% in MEX compilation might like to make their own compilations.  To this
% end one should edit the file <matlab:edit('makemex') makemex>,
% introducing the proper compilation options and flags, and run the file
% |makemex|.
%
% Copyright 2017 Ulrich Hohenester