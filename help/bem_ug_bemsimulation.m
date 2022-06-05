%% BEM simulations
%
% The MNPBEM toolbox provides a number of different simulation approaches.
% Which one is the best depends on the problem under study and on the taste
% of the user.  In the following we give a few ideas and provide some
% advices for unexperienced users.
%
%% Quasistatic simulations
%
% For small metallic nanoparticles, say for dimensions below 100 nm,
% quasistatic simulations will usually give good results which are not very
% different from the more time-consuming retarded simulations. Quasistatic
% simulations have the advantage that they are really fast.  In addition,
% our BEM implementation gives particularly accurate results for most
% quasistatic simulations.
%
% Another advantage of the quasistatic approach is that surface charges can
% be interpreted in terms of so-called plasmonic eigenmodes, which can be
% computed with the <matlab:doc('plasmonmode') plasmonmode> function.
%
%% Retarded simulations
%
% In retarded simulations the full Maxwell equations are solved.  These
% simulations are usually much slower than the quasistatic ones, and one
% should carefully check whether they are really needed.
%
% When implementing new features with the toolbox, it is often a good idea
% to compare for small nanoparticles quasistatic and retarded simulations.
% As the two implementations are completly different, such a comparison
% often allows to detect errors.
%
% Retarded simulations have been frequently carried out by us and other
% users in the past, for structure dimensions ranging from a few nanometers
% up to a few micrometers, and we have been satisfied with our simulation
% results throughout.
%
%% Simulations with layer structures
% 
% In many cases it is good practice to use instead of the layer structure
% an effective-medium approach, where the nanoparticle is embedded in a
% dielectric background with an average of the dielectric functions of
% upper and lower medium.  The resulting simulations are fast and
% efficient, and will give in most cases good results.
%
%% Simulations using iterative solvers
%
% Simulations with the iterative BEM solvers can be sufficiently faster and
% less memory-consuming than simulations with the normal BEM solvers, in
% particular for nanoparticles consisting of several 1000 to 10 000
% boundary elements.  The speedup and memory reduction depend on the
% particle geometry and the chosen parameters.  At present our
% implementation is still somewhat experimental, and it is likely that
% future versions of the toolbox will benefit from further improvements.
%
% As the iterative solvers make extensive use of MEX functions, it might be
% that in case of bugs the program terminates by causing a fatal Matlab
% error.
%%
% Copyright 2017 Ulrich Hohenester