%% Simulations with layer structures
%
% In the simulation with substrates or layer structures, one has to be
% careful about a few things
%
% * The nanoparticle must be placed properly within the layer structure.
% * The tables for the reflected Green functions must be set properly.
% * When re-using previously computed Green function tables, the grid size
% ranges must be compatible.
%
% In the following we briefly discuss how this should be done.  Further
% examples can be found in the <bem_example.html demo files>.
%
%% Placing particles in layer structures
%
% It is impotant that all boundary points of the nanoparticle can be
% uniquely assigned to one of the layers.  Problems may arise for curved
% particle where one of the integration points falls into a different
% medium, although all centroids are positioned properly, and for flat
% nanoparticles where points must not lie directly on one of the
% interfaces.  For this reason, the distance of the nanoparticle to the
% interface should be chosen sufficiently large.
%
% Let us first investigate the situation where a gold nanosphere with a
% diameter of 10 nm is located 1 nm above a glass substrate.

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 2.25 ) };
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], 0 );
%  nanosphere with diameter of 10 nm, 1 nm above substrate
p = shift( trisphere( 144, 10 ), [ 0, 0, 6 ] );
%  set up COMPARTICLE object
p = comparticle( epstab, { p }, [ 2, 1 ], 1 );

%%
% For a nanodisk sitting on top of the substrate we can use an
% <bem_ug_edgeprofile.html edge profile> with sharp edges at the bottom,
% and place the particle slightly above the substrate.  It is important
% that the particle is closer than |layer.ztol| to the substrate such that
% the BEM solvers can assign the bottom boundary elements to the layer.

%  polygon for nanodisk
poly = polygon( 30, 'size', [ 30, 30 ] );
%  edge profile with rounded edges on top and sharp edges on bottom, place
%  minimum of edge slighly above substrate
edge = edgeprofile( 5, 'mode', '01', 'min', 1e-3 );
%  make nanodisk
p = comparticle( epstab, { tripolygon( poly, edge ) }, [ 2, 1 ], 1 );

%%
% One can check that the particle is indeed located slightly above the
% substrate with
%
%    >> min( p.pos )
%
%    ans =
% 
%    -15.2969  -15.2969    0.0009
%
%% Setting up tabulated Green functions
%
% For simualtions based on the solution of the full Maxwell equations, one
% has to set up a table for the reflected Green functions.  For quasistatic
% simulations, which only work for substrates, this is not necessary since
% the reflected Green function can be computed by means of image charges.
%
% Users who are not overly familiar with the tabulated Green functions are
% adviced to use a calling sequence where
%
% * the Green functions are only computed when this is necessary, and to
% * use an automatic grid setting.
%
% In the following example we assume that |p| is a comparticle object,
% |enei| is an array of wavelengths, and we want to compute scattering or
% extinction spectra for the given wavelengths.  To assure a proper setting
% of the tabulated Green function grid, one calls

if ~exist( 'greentab', 'var' ) || ~greentab.ismember( layer, enei, p )
  %  automatic grid for tabulation
  tab = tabspace( layer, p, 'nz', 20 );
  %  Green function table
  greentab = compgreentablayer( layer, tab );
  %  precompute Green function table
  greentab = set( greentab, enei, op );
end
op.greentab = greentab;

%%
% In the first line we check whether |greentab| has been previously
% computed, and if yes whether the grid settings are compatible with the
% current simulation.  If this is not the case, we automatically create a
% grid table |tab| and compute the table.  Finally, the Green function
% table is added to the option structure.
%
% A similar calling sequence can be used when one also wants to compute
% the electromagnetic fields around the particle

%  grid where fields will be computed
[ x, z ] = meshgrid( linspace( - 30, 30, 81 ), linspace( - 30, 60, 101 ) );
%  make compoint object
%    it is important that COMPOINT receives the OP structure because it has
%    to group the points within the layer structure
pt = compoint( p, [ x( : ), 0 * x( : ), z( : ) ], op );

if ~exist( 'greentab', 'var' ) || ~greentab.ismember( layer, enei, p, pt )
  %  automatic grid for tabulation
  tab = tabspace( layer, p, pt, 'nz', 20 );
  %  Green function table
  greentab = compgreentablayer( layer, tab );
  %  precompute Green function table
  greentab = set( greentab, enei, op );
end
op.greentab = greentab;

%% Examples
%
% Several examples for simulations with layer structures can be found in
% the <bem_example.html demo files> section.
% 
% Copyright 2017 Ulrich Hohenester