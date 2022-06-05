%% Mie solver
%
% For spherical nanoparticles there exist a number of analytic results, for
% both quasistatic and retarded simulations, which are derived within the
% framework of Mie theory.  The MNPBEM toolbox has implemented a few Mie
% classes that can be used for testing purposes.
%
%% Initialization

%  Mie solver for spherical nanoparticle
mie = miesolver( epsin, epsout, diameter, op, PropertyName, PropertyValue );
%  Mie-Gans solver for ellipsoidal nanoparticle and quasistatic simulation
mie2 = miegans( epsin, epsout, ax );

%%
% In the initialization, the following parameters and additional properties
% are used
%
% * *|epsin|* is the dielectric function of the nanosphere.
% * *|epsout|* is the dielectric function of the embedding medium.  In the
% present implementation, |epsout| must be a dielectric constant.
% * *|diameter|* is the diameter of the nanosphere.
% * *|ax|* are the axes of the nanoellipsoid used for Mie-Gans simulations.
% * *|op|* is the MNPBEM option structure.
% * *|'lmax'|* determines the maximum umber for spherical harmonic degrees
% (20 on default).
%
% |miesolver| is a wrapper function that selects from the options and
% property settings the right class.
%
%% Methods
%
% Once the |miesolver| object is initialized, one can compute the following
% quantities

%  scattering, extinction and absorption cross sections
sca = mie.sca( enei );
ext = mie.ext( enei );
abs = mie.abs( enei );
%  total and radiative decayrate for dipole positions (0,0,z) and
%  orientation of the dipole transition moment along x and z in units of
%  the free-space decay rate of the embedding medium
[ tot, rad ] = mie.decayrate( enei, z );
%  energy loss probability for electron in EELS, works only for EPSOUT = 1
%    IMP is the impact parameter for the fast electron with a trajectory
%    that must not penetrate the sphere, and VEL is the electron velocity
%    in units of the speed of light.  PRAD is the photon loss probability
%    which can be measured in cathodoluminescence.
[ prob, prad ] = mie.loss( imp, enei, vel );

%%
% For quasistatic Mie-Gans theory, only the cross sections can be computed
% and one additionally has to provide the light polarization

%  scattering, extinction and absorption cross sections
sca = mie2.sca( enei, pol );
ext = mie2.ext( enei, pol );
abs = mie2.abs( enei, pol );

%% Examples
%
% A comparison of results derived within Mie, Mie-Gans theory and the BEM
% simulations is given in several of the <bem_example.html demo> files.
%
%
% Copyright 2017 Ulrich Hohenester