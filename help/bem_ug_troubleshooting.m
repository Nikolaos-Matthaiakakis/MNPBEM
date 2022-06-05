%% Troubleshooting
%
% There are a number of things that can go wrong with MNPBEM toolbox
% simulations.  In the following we list some of the common mistakes and
% give some advice for improving the runtimes of MNPBEM simulations.
%
%% Errors
%
% * *|assert|* When the simulation stops with an <matlab:doc('assert')
% assert> error, one should open the file where the |assert| expression
% failed and read the comment line above the |assert| statement.
% * *|epstable|* In particular for tabulated dielectric functions it often
% happens that |enei| spans a larger wavelength range than the tabulated
% values.
% * *|nvec|* When a simulation gives wrong results, in particular no
% pronounced plasmon resonance for metallic nanoparticles, this is often
% the case because the orientation of the boundary elements is in wrong
% order.  The order determines the direction of the outer surface normal,
% which defines the in- and outside of particle boundaries.  One can check
% the direction of the outer surface normals with
% <matlab:plot2(trisphere(144),'EdgeColor','b','nvec',1)
% plot(p,'EdgeColor','b','nvec',1)>.
% * *|closed|* To check whether the |closed| argument of the
% <bem_ug_comparticle.html comparticle> object has been set properly, one
% can set the face boundaries to curved (|op.interp='curv'|) and run a
% simulation without |closed| argument.  The results should not be too
% different.
% * *|refine|* If the simulation results are unstable and depend strongly
% on the degree of discretization, one should try to increase the |refine|
% argument of the <bem_ug_options.html options>.
% * *|compgreentab|* Grids for tabulated Green functions have to be set
% properly.  If the grid size is not large enough, the program will
% probably stop in the <matlab:doc('layerstructure/round') round> function
% of the |layerstructure| object.  In such cases one might consider to set
% the grid size <bem_ug_layergreen.html manually>.
% * *|clear classes|* Often it is a good idea to clear all classes by
% typing |clear classes| at the Matlab prompt and to re-start the
% simulation.
%
%% Improving simulations
%
% For improving the performance of simulations, one should regularly run
% the Matlab profiler and carefully inspect where most of the computer time
% is used.
%
% Copyright 2017 Ulrich Hohenester