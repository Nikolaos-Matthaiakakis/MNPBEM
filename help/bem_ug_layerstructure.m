%% The layerstructure class
%
% For particles embedded in layer structures or situated on a substrate,
% one has to set up a layer structure.  This can be done with the
% |layerstructure| class.
%
%% Initialization

%  initialize layer structure
layer = layerstructure( epstab, ind, ztab,     PropertyName, PropertyValue );
layer = layerstructure( epstab, ind, ztab, op, PropertyName, PropertyValue );

%%
% In the initialization, the following parameters are used
%
% * *|epstab={eps1,eps2,...}|* is a table of dielectric functions.  This
% table must be identical to the one used for |comparticle| objects.
% * *|ind|* points for the different layers to the dielectric functions
% given by the corresponding entries in |epstab|.
% * *|ztab|* is an array for the z-positions of the layer interfaces.
% 
%
%              eps{ ind( 1 ) }
%       --------------------------  z( 1 )
%              eps{ ind( 2 ) }
%       --------------------------  z( 2 )
%                   ...
%       --------------------------  z( end )
%              eps{ ind( end ) }
%
%
% In addition to the above parameters, one can set the following properties
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
% For quasistatic simulations only substrates (with one single interface)
% are allowed.  Once the |layerstructure| object is initialized, it should
% be added to the MNPBEM option structure

%  add LAYERSTRUCTURE to option structure
op.layer = layer;

%% Methods
%
% Layer structurs have a number of <matlab:doc('layerstructure') methods>
% that are used by the BEM solvers, Green functions and excitation classes.
% These methods include for retarded simulations

%  set up TABSPACE for tabulated Green functions
tab = tabspace( layer, p, pt );
%  compute reflected Green functions
[ G, Fr, Fz ] = green( layer, enei, r, z1, z2 );
%  compute Fresnel coefficients
[ e, k ] = efresnel( layer, pol, dir, enei );

%%
% The |tabspace| function will be discussed in more for the
% <ug_bem_layergreen.html tabulated Green function>.  Details about the
% reflected Green function and the Fresnel coefficients can be found in the
% headers of the corresponding files.
%
%% Implementation
%
% For quasistatic simulations, we employ the method of image charges to
% compute the reflected Green functions.  For the calculation of the
% reflected Green functions in the retarded case we use the approach of
%
% * M. Paulus et al., Phys. Rev. E *62*, 5797 (2000).
%
% This approach has been adapted for the potential-based BEM approach for
% the solution of the full Maxwell equations.
%
%% Examples
%
% In the first example we set up a substrate with glass and air.  The
% interface is at z=0.

%  table of dielectric functions (same as for COMPARTICLE object)
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 2.25 ) };
%  interface position
ztab = 0;
%  default options for layer structure
opt = layerstructure.options;
%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab, opt );

%%
% In the second example we consider an additional thin layer with
% dielectric constant 10 located above the substrate.

%  table of dielectric functions (same as for COMPARTICLE object)
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 2.25 ), epsconst( 10 ) };
%  interface position
ztab = [ 4, 0 ];
%  default options for layer structure
opts = layerstructure.options;
%  set up layer structure
layer = layerstructure( epstab, [ 1, 4, 3 ], ztab, opt );

%%
% 
% Copyright 2017 Ulrich Hohenester