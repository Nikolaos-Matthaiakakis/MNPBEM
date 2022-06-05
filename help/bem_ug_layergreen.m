%% Tabulated Green functions
%
% For particles embedded in layer structures or situated on a substrate,
% one has to compute the reflected Green functions for simulations using
% the full Maxwell equations.  As the computation of these Green functions
% requires to evaluate Sommerfeld integrals which are computationally
% rather expensive, within the MNPBEM toolbox the reflected Green functions
% are computed on a suitable grid only once at the beginning of the
% simulation. In principle, these tabulated functions can be saved and
% re-used for other simulations.  During the simulation, the reflected
% Green functions are then obtained through interpolation of the tabulated
% ones.
%
%% Initialization

%  initialize tabulated Green function object on grid TAB
g = compgreentablayer( layer, tab );
g = compgreentablayer( layer, [ tab1, tab2 ] );

%  compute table of reflected Green functions for array of wavelengths ENEI
greentab = set( greentab, enei, op );
%  same as above but using PARFOR loop for parallel computing
%    a parallel pool must have been opened before by the user
greentab = parset( greentab, enei, op );

%  add GREENTAB object to options structure
op.greentab = greentab;

%%
% In the initialization, the following parameters are used
%
% * *|layer|* is a <bem_ug_layerstructure.html layerstructure> object
% defining the layer structure or the substrate.
% * *|tab|* is a structure array that defines the grid on which the
% reflected Green functions are computed.
%
% The computation of the table of reflected Green function can be
% time-consuming.  For this reason it might be useful to save the Green
% function table and re-use it for simulations of different nanoparticles
% with the same substrate.
% 
%% Setting up the grid
%
% Defining the grid for the reflected Green functions can be done manually
% (see below) or automatically.  Users that are not willing to dig into the
% details of the implementation should stay with the automatic table
% generation

%  Green function mesh for BEM simulation with particle P
tab = tabspace( layer, p, PropertyName, PropertyValue );
%  mesh for particle P, and compute fields at COMPOINT positions PT
tab = tabspace( layer, p, pt, PropertyName, PropertyValue );
%  mesh for particle P and for dipole excitations at COMPOINT positions PT
tab = tabspace( layer, { p, pt }, PropertyName, PropertyValue );
%  mesh for particle P, dipoles at PT, and computation of fields at PT2
tab = tabspace( layer, { p, pt }, pt2, PropertyName, PropertyValue );

%%
% In |tabspace| the following additional properties can be set
%
% * *|'scale'|* scale factor to enlarge grid size,
% * *|'range'|* set to 'full' if the nanoparticle is located slightly above
% the layer interface and you want to tabulate the Green function starting
% from the interface,
% * *|'nr'|* number of r-values for automatic grid,
% * *|'nz'|* number of z-values for automatic grid.
%
% Quite generally, the evaluation of the tabulated Green functions is only
% fast when particle |p| and positions |pt| are both located in the
% uppermost medium of the layer structre (above a substrate).  Otherwise
% the evaluation can take several minutes to hours.
%
%% Tips and tricks
%
% The |tabspace| function has been implemented only lately.  We have tried
% to make the implementation as user-friendly as possible, such that the
% automatic mesh generation works properly in all cases.  In testing the
% |tabspace| function and using it in real-life simulations, we have been
% surprised how many things can go wrong.  We hope that the present
% |tabspace| implementation works properly in most cases.  However, if the
% program produces a runtime error in the
% <matlab:doc('layerstructure/round') layerstructure/round> function it is
% likely that something went wrong with the automatic mesh generation.
%
% If the computation of the tabulated Green functions is very time
% consuming, one might consider computing them once and then saving the
% table on the hard disk for later use.  Green functions with properly set
% meshes can be re-used for various nanoparticle simulations placed in the
% same layer structure.
%
%% Details about the Green function grid
%
% The reflected Green function _G(r,z1,z2)_ depends on
%
% * *_r_* the radial distance between the source and observation point,
% * *_z1_* the z-value of the observation point, and 
% * *_z2_* the z-value of the source point.
%
% In setting up the grid, one must set up for each layer a separate table
% such that all _z1_- and _z2_-values lie within only one medium.
%
% Consider a layer structure with three layers, where the particle is
% located above the last interface.  We then have to set up only one grid 
%
%            eps1   eps2   eps3  
%
%     eps1     x     -      -
%     eps2     -     -      -
%     eps3     -     -      -
%
% When we want to compute the field for this configuration also in the
% middle layer, we need two grids (rows for _z1_, colums for _z_2)
%
%            eps1   eps2   eps3  
%
%     eps1     x     -      -
%     eps2     x     -      -
%     eps3     -     -      -
%
% If two nanoparticles are located in layers 1 and 2, we have to set up
% four grids since the boundary elements of the particle act as both
% observation and source points for the Green function
%
%            eps1   eps2   eps3  
%
%     eps1     x     x      -
%     eps2     x     x      -
%     eps3     -     -      -
%
% When both observation and source points lie in the uppermost or lowermost
% layer, one can additionally use that the Green function only depends on
% two variables, namely _G(r,z1+z2)_.  
%
% One can manually set the grids through

tab = tabspace( layer, [ rmin, rmax, nr ], [ z1min, z1max, nz1 ], [ z2min, z2max, nz2 ] );

%%
% Here |min| and |max| correspond to the maximal values, and |n| to the
% number of grid points.  Note that the |z1| and |z2| values must be chosen
% such that they do not lie _on_ an interface of the layer structure.  If
% |rmin| is smaller than |layer.rmin| or one of the z-values is closer than
% |layer.zmin| to one of the interfaces, the value will be automatically
% rounded.
%
%% Examples
%
% Consider a substrate where a nanosphere with 10 nm radius is situated 4
% nm above the interface.  A suitable grid is

%  set up grid for nanosphere above substrate, interface position ZTAB
%    - the largest radial distance between two points is 10 nm, add a little bit for safety
%    - the largest z1-value is 14 nm, make grid for z1 + z2 = 28 nm and add a bit
%    - indicate that z2 lies in upper medium
tab = tabspace( layer, [ 0, 15, 30 ], [ ztab + 1e-10, ztab + 35, 30 ], ztab + 1e-10 );

%%
% An automatic choice for the particle |p| would be

tab = tabspace( layer, p, 'nz', 30 );

%%
% If we consider the same structure but want to compute the fields also in
% the lower substrate, we need another grid
tab2 = tabspace( layer, [ 0, 15, 30 ], [ ztab - 1e-10, ztab - 10, 20 ],  ...
                                       [ ztab + 1e-10, ztab + 35, 20 ] );

%%
% 
% Copyright 2017 Ulrich Hohenester