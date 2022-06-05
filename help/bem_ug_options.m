%% Options for the MNPBEM toolbox
%
% The performance of the MNPBEM toolbox can be controlled through an
% option structure.
%
%% Initialization

%  initialize option structure and set properties
op = bemoptions( PropertyName, PropertyValue );
%  add additional arguments to option structure
op = bemoptions( op, PropertyName, PropertyValue );

%%
% |op| is a structure that holds the properties that control the BEM
% simulation.  Once |op| is initialized, it can be passed to the MNPBEM
% classes through

%  pass option structure OP to class BEMCLASS
obj = bemclass( varargin, op );
%  pass additional arguments
obj = bemclass( varargin, op, PropertyName, PropertyValue );

%% BEM options
%
% * *|'AbsCutoff'|* controls the refined particle boundary integration, as
% discussed in <bem_ug_integration.html particle integration>.
% * *|'deriv'|* selects between Cartesian coordinates (|'cart'|, default)
% and only surface normals (|'norm'|) for Green functions in the BEM
% solvers.
% * *|'eels.cutoff'|* is a cutoff parameter for EELS simulations that
% determines boundary elements where a refined integration is performed.
% * *|'eels.refine'|* controls the number of integration points for EELS
% simulations.
% * *|'greentab'|* is the tabulated reflected Green function needed for the
% simulation of layer structures and substrates.
% * *|'interp'|* selects between flat (|'flat'|) and curved (|'curv'|)
% particle boundaries.
% * *|'layer'|* defines a layer structure or substrate.
% * *|'nev'|* sets the number of eigenvalues for BEM solvers with an
% eigenmode expansion.
% * *|'npol'|* controls the number of integration points for diagonal Green
% function elements.
% * *|'order'|* controls the order for the Taylor series expansion in the
% evaluation of the retarded Green function.
% * *|'pinfty'|* provides a user-defined unit-sphere discretization used
% for the computation of scattering rates.
% * *|'refine'|* controls the number of integration points for off-diagonal
% Green function elements.
% * *|'RelCutoff'|* controls the refined particle boundary integration, as
% discussed in <bem_ug_integration.html particle integration>.
% * *|'rule'|* selects the integration rule (default 18) for triangle
% integration.
% * *|'sim'|* selects between quasistatic (|'stat'|) and retarded (|'ret'|)
% simulations.
% * *|'sym'|* selects a BEM simulation with mirror symmetry.
% * *|'waitbar'|* controls whether the progress of various BEM functions is
% reported through a waitbar or not.
%
% The following options can be passed to |layerstructure| objects and can
% be set through |op=layerstructure.options|
%
% * *|'ztol'|* boundary elements located closer than |ztol| to the layer
% interface are considered to belong to the layer.
% * *|'rmin'|* minimum radial distance for Green function tabulation and
% evalulation.
% * *|'zmin'|* minimum distance to layer for Green function tabulation and
% evalulation.
% * *|'semi'|* semicircle for evalulation of reflected Green function in
% complex plane, see M. Paulus et al., PRE *62*, 5797 (2000).
% * *|'ratio'|* controls whether Bessel or Hankel functions are used in the
% evalulation of the reflected Green function, see M. Paulus et al.
% * *|'op'|* additional option structure that controls <matlab:doc('ode45')
% ode45> integration in the complex plane.
%
% The following options can be passed to |bemiter| objects and can
% be set through |op.iter=bemiter.options| (see also <bem_ug_iter.html
% iterative BEM solvers>)
%
% * *|'solver'|* selects between the different iterative solvers
% <matlab:doc('cgs') cgs>, <matlab:doc('bicgstab') bicgstab>, and
% <matlab:doc('gmres') gmres> for the solution of the system of linear
% equations underlying our BEM approach.
% * *|'tol'|* selects the tolerance of the iterative solver.
% * *|'maxit'|* determines the maximum number of iterations.
% * *|'restart'|* is the number of restarts used by <matlab:doc('gmres')
% gmres>.
% * *|'precond'|* determines the preconditioner.  At present we recommend
% to not change the default setting |'hmat'|.
% * *|'output'|* turns on (1) or off (0) any intermediate output of the
% iterative BEM solver.
% * *|'cleaf'|* determines the minimum cluster size.
% * *|'htol'|* is the tolerance for the H-matrix compression.
% * *|'kmax'|* is the maximum rank for H-matrix compression.
% * *|'fadmiss'|* is a function for the admissibility criterion for cluster
% pairs.
%
% Copyright 2017 Ulrich Hohenester