%% MNPBEM Toolbox
%
% <<../figures/mnpbemlogo.jpg>>
%
%% Short description of the toolbox
%
% MNPBEM is a toolbox for the simulation of metallic nanoparticles (MNP),
% using a boundary element method (BEM) approach developed by F. J. Garcia
% de Abajo and A. Howie, Phys. Rev. B *65*, 115418 (2002).  The main
% purpose of the toolbox is to solve Maxwell's equations for a dielectric
% environment where bodies with homogeneous and isotropic dielectric
% functions are separated by abrupt interfaces. Although the approach is in
% principle suited for arbitrary body sizes and photon energies, it is
% tested (and probably works best) for metallic nanoparticles with sizes
% ranging from a few to a few hundreds of nanometers, and for frequencies
% in the optical and near-infrared regime.
%
% From our experience with the toolbox it appears that there exist no
% "standard" applications, but each problem requires a slightly different
% implementation.  For this reason we have decided to provide a set of
% general Matlab(R) classes that can be easily combined to simulate the
% problem of interest.  This means, however, that some knowledge about the
% working principle of the BEM approach is needed, as will be provided in
% the following help pages.  We have also introduced a number of examples
% that can be used as templates for other simulations.
%
% Throughout the MNPBEM toolbox, lengths are measured in
% nanometers and photon energies through the light wavelength $\lambda$ (in
% vacuum) in nanometers.  In the programs we use  for $\lambda$ the
% notation |enei| (inverse of photon energy).  With the only exception of
% the classes for the dielectric function, one could also measure distances
% and wavelengths in other units such as e.g. micrometers or atomic units.
%
%% Reference
%
% *_When publishing results obtained with the MNPBEM toolbox, we ask you to
% cite one or several of the following papers_*:
%
% * U. Hohenester and A. Trügler, Comp. Phys. Commun. *183*, 370 (2012).
% * U. Hohenester, Comp. Phys. Commun. *185*, 1177 (2014).
% * J. Waxenegger, A. Trügler, and U. Hohenester, Comp. Phys. Commun.
% *193*, 138 (2015).
%
% We cordially acknowledge Christine Prietl for providing us with a SEM
% image of the MNPBEM letters, which has been used as a template for the
% MNPBEM logo. 
%
%
%% Copyright
%
% The MNPBEM toolbox is distributed under the terms of the GNU General
% Public License.  See the file COPYING in the main directory for license
% details.
%
%% Developers
%
% <http://physik.uni-graz.at/~uxh Ulrich Hohenester>, 
% <http://physik.uni-graz.at/~atr Andreas Trügler>
%
% Copyright 2017 Ulrich Hohenester

