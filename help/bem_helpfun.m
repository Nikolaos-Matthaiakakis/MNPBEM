%% Functions and classes of the MNPBEM Toolbox
%
% <<../figures/mnpbemlogo.jpg>>
%
% The toolbox includes a number of classes and functions.
%
%% Base
%
% * <matlab:doc('bembase') @bembase> - Abstract base class for MNPBEM classes.
% * <matlab:doc('bemsolver') bemsolver.m> - Select appropriate BEM solver using options.
% * <matlab:doc('dipole') dipole.m> - Initialize dipole excitation.
% * <matlab:doc('electronbeeam') electronbeam.m> - Initialize electron excitation for EELS simulation.
% * <matlab:doc('greenfunction') greenfunction.m> - Initialize Green function.
% * <matlab:doc('planewave') planewave.m> - Initialize plane wave excitation.
% * <matlab:doc('spectrum') spectrum.m> - Initialize spectrum.
%
%% BEM
%
% * <matlab:doc('bemiter') @bemiter> - Base class for iterative BEM solvers.
% * <matlab:doc('bemret') @bemret> - BEM solver for full Maxwell equations.
% * <matlab:doc('bemretiter') @bemretiter> -  Iterative BEM solver for full Maxwell equations.
% * <matlab:doc('bemretlayer') @bemretlayer> - BEM solver for full Maxwell equations and layer structure.
% * <matlab:doc('bemretlayeriter') @bemretlayeriter> - Iterative BEM solver for full Maxwell equations and layer structure.
% * <matlab:doc('bemretmirror') @bemretmirror> -  BEM solver for full Maxwell equations with mirror symmetry.
% * <matlab:doc('bemstat') @bemstat> - BEM solver for quasistatic approximation.
% * <matlab:doc('bemstatiter') @bemstatiter> - Iterative BEM solver for quasistatic approximation.
% * <matlab:doc('bemstateig') @bemstateig> - BEM solver for quasistatic approximation and eigenmode expansion.
% * <matlab:doc('bemstateigmirror') @bemstateigmirror> BEM solver for quasistatic approximation using mirror symmetry.
% * <matlab:doc('bemstatlayer') @bemstatlayer> - BEM solver for quasistatic approximation and layer structure.
% * <matlab:doc('bemstatmirror') @bemstatmirror> - BEM solver for quasistatic approximation with mirror symmetry.
% * <matlab:doc('plasmonmode') plasmonmode.m> - Compute plasmon eigenmodes for discretized surface.
%
%% Greenfun
%
% * <matlab:doc('compgreenret') @compgreenret> - Green function for composite points and particle.
% * <matlab:doc('compgreenrelayer') @compgreenrelayer> - Green function for layer structure.
% * <matlab:doc('compgreenretmirror') @compgreenretmirror> - Green function for composite particles with mirror symmetry.
% * <matlab:doc('compgreenstat') @compgreenstat> - Green function for cquasistatic approximation.
% * <matlab:doc('compgreenstatlayer') @compgreenstatlayer> - Green function for layer structure in quasistatic limit.
% * <matlab:doc('compgreenstatmirror') @compgreenstatmirror> - Quasistatic Green function for composite particles with mirror symmetry.
% * <matlab:doc('compgreentablayer') @compgreentablayer> -  Green function for layer structure and different media.
% * <matlab:doc('greenret') @greenret> - Green functions for solution of full Maxwell equations. 
% * <matlab:doc('greenretlayer') @greenretlayer> - Green function for reflected part of layer structure.
% * <matlab:doc('greenstat') @greenstat> - Green functions for quasistatic approximation. 
% * <matlab:doc('greentablayer') @greentablayer> - Green function for layer structure.
% * <matlab:doc('aca.compgreenret') @aca.compgreenret> - Green function for full Maxwell's equations and ACA..
% * <matlab:doc('aca.compgreenretlayer') @aca.compgreenretlayer> - Green function for layer structure using full Maxwell's equations and ACA.
% * <matlab:doc('aca.compgreenstat') @aca.compgreenstat> - Green function quasistatic approximation using ACA.
% * <matlab:doc('clustertree') @clustertree> - Build cluster tree through bisection.
% * <matlab:doc('hmatrix') @hmatrix> - Hierarchical matrix.
%
%% Material
%
% * <matlab:doc('epsconst') @epsconst> - Dielectric constant.
% * <matlab:doc('epsdrude') @epsdrude> - Drude dielectric function.
% * <matlab:doc('epstable') @epstable> - Interpolate from tabulated values of dielectric function.
% * <matlab:doc('epsfun') @epsfun> - Dielectric function using user-supplied function.
%
%% Mie
%
% * <matlab:doc('miegans') @miegans> - Mie-Gans theory for ellipsoidal particle and quasistatic approximation.
% * <matlab:doc('mieret') @mieret> - Mie theory for spherical particle using the full Maxwell equations.
% * <matlab:doc('miestat') @miestat> - Mie theory for spherical particle using the quasistatic approximation.
% * <matlab:doc('miesolver') miesolver.m> - Initialize solver for Mie theory.
%
%% Misc
%
% * <matlab:doc('bemplot') @bemplot> - Plotting value arrays and vector functions within MNPBEM.
% * <matlab:doc('arrowplot') arrowplot.m> - Plot vectors at given positions using arrows.
% * <matlab:doc('bemoptions') bemoptions.m> - Set standard options for MNPBEM simulation.
% * <matlab:doc('coneplot') coneplot.m> - Plot vectors at given positions using cones.
% * <matlab:doc('coneplot') coneplot2.m> - Plot vectors at given positions using cones.
% * <matlab:doc('inner') inner.m> - Inner product between a vector and a matrix or tensor.
% * <matlab:doc('outer') outer.m> - Outer product between vector and tensor.
% * <matlab:doc('particlecursor') particlecursor.m> - Find surface elements of discretized particle surface.
% * <matlab:doc('patchcurvature') patchcurvature.m> - Principal curvature values of a triangulated mesh. 
% * <matlab:doc('subarray') subarray.m> - Pass arguments to subsref.
% * <matlab:edit('units') units.m> - Conversion between eV and nm.
% * <matlab:doc('vecnorm') vecnorm.m> - Norm of vector array.
% * <matlab:doc('vecnormalize') vecnormalize.m> - Normalize vector array.
%
%% Particles
%
% * <matlab:doc('comparticle') @comparticle> - Compound of particles in a dielectric environment.
% * <matlab:doc('comparticlemirror') @comparticlemirror> - Compound of particles with mirror symmetry in a dielectric environment.
% * <matlab:doc('compoint') @compoint> - Compound of points in a dielectric environment.
% * <matlab:doc('compound') @compound> - Compound of points or particles within a dielectric environment.
% * <matlab:doc('compstruct') @compstruct> - Structure for compound of points or particles.
% * <matlab:doc('compstructmirrore') @compstructmirror> - Structure for compound of points or particles with mirror symmetry.
% * <matlab:doc('layerstructure') @layerstructure> - Dielectric layer structures.
% * <matlab:doc('particle') @particle> - Faces and vertices of discretized particle.
% * <matlab:doc('point') @point> - Collection of points.
% * <matlab:doc('polygon') @polygon> - 2D polygons for use with Mesh2d.
%
% *Particle shapes*
%
% * <matlab:doc('edgeprofile') @edgeprofile> - Profile of smoothed edge for use with TRIPOLYGON.
% * <matlab:doc('polygon3') @polygon3> - 3D polygon for extrusion of particles.
% * <matlab:doc('tricube') tricube.m> - Cube particle with rounded edges.
% * <matlab:doc('tripolygon') tripolygon.m> - 3d particle from polygon.
% * <matlab:doc('trirod') trirod.m> - Faces and vertices for rod-shaped particle.
% * <matlab:doc('trisphere') trisphere.m> - Load points on sphere from file and perform triangulation.
% * <matlab:doc('trispherescale') trispherescale.m> - Deform surface of sphere.
% * <matlab:doc('trispheresegment') trispheresegment.m> - Discretized surface of sphere.
% * <matlab:doc('tritorus') tritorus.m> - Faces and vertices of triangulated torus.
%
%% Simulation
%
% *Misc*
%
% * <matlab:doc('eelsbase') @eelsbase> - Base class for electron energy loss spectroscopy (EELS) simulations.
% * <matlab:doc('meshfield') @meshfield> - Compute electromagnetic fields for a grid of positions.
%
% *Quasistatic*
%
% * <matlab:doc('dipolestat') @dipolestat> - Excitation of an oscillating dipole in quasistatic approximation.
% * <matlab:doc('dipolestatlayer') @dipolestatlayer> - Excitation of an oscillating dipole in quasistatic approximation.
% * <matlab:doc('dipolestatmirror') @dipolestatmirror> -  Excitation of an oscillating dipole  using mirror symmetry.
% * <matlab:doc('eelsstat') @eelsstat> - Excitation of an electron beam with a high kinetic energy.
% * <matlab:doc('planewavestat') @planewavestat> - Plane wave excitation within quasistatic approximation.
% * <matlab:doc('planewavestatlayer') @planewavestatlayer> - Plane wave excitation within quasistatic approximation for layer structure.
% * <matlab:doc('planewavestatmirror') @planewavestatmirror> - Plane wave excitation within quasistatic approximation for mirror symmetry.
% * <matlab:doc('spectrumstat') @spectrumstat> - Compute far fields and scattering cross sections in quasistatic limit.
% * <matlab:doc('spectrumstatlayer') @spectrumstatlayer> - Compute far fields and scattering cross sections for layer structure.
%
% *Retarded*
%
% * <matlab:doc('dipoleret') @dipoleret> - Excitation of an oscillating dipole.
% * <matlab:doc('dipoleretlayer') @dipoleretlayer> - Excitation of an oscillating dipole.
% * <matlab:doc('dipoleretmirror') @dipoleretmirror> - Excitation of an oscillating dipole.
% * <matlab:doc('eelsret') @eelsret> - Excitation of an electron beam with a high kinetic energy.
% * <matlab:doc('planewaveret') @planewaveret> - Plane wave excitation for solution of full Maxwell equations.
% * <matlab:doc('planewaveretlayer') @planewaveretlayer> - Plane wave excitation for layer structure.
% * <matlab:doc('planewaveretmirror') @planewaveretmirror> - Plane wave excitation using mirror symmetry.
% * <matlab:doc('spectrumret') @spectrumret> - Compute far fields and scattering cross sections.
% * <matlab:doc('spectrumretlayer') @spectrumretlayer> - Compute far fields and scattering cross sections for layer structure.
%
%
% Copyright 2017 Ulrich Hohenester