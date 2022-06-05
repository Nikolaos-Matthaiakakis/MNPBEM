%% Pros and cons of the MNPBEM Toolbox
%
% Here we briefly comment on the pros and cons for using the MNPBEM
% toolbox.  At the end we also describe what you should do if you find an
% error in the program.
%
%% Why Matlab ?
%
% Matlab is an extremely flexible environment for simulation and
% visualization purposes.  For high-performance computing Matlab is less
% attractive because commands are interpreted, and only the basic
% operations, such as matrix inversion or diagonalization,  rely on
% compiled code.  On the other hand, in the BEM solvers, which are at the
% heart of the MNPBEM toolbox, most of the time is consumed for precisely
% such matrix operations, and we thus expect Matlab to be a good choice.
%
%% Advantages and disadvantages of the toolbox
%
% The potential-based BEM approach developed by F. J. Garcia de Abajo and
% A. Howie, Phys. Rev. B *65*, 115418 (2002), has the advantage that the
% size of the matrices to be manipulated is given by the number |n| of
% surface elements (in comparison to the size |3*n| for field-based BEM
% schemes).  In addition, the potentials produced by the surface charges
% and currents have a weaker spatial dependence, which allows for the use
% of a collocation approach.  Here, the surface charges and currents are
% taken at the centroids of each surface element.  Such a simple approach
% would not be possible for field-based BEM approaches.  In the MNPBEM
% toolbox the fields and potentials are computed by summing over all
% surface elements.  A significant speed-up could probably be obtained by
% using multipole methods, but be have refrained from such an approach
% because of its conceptual complexity.
%
% We believe that the toolbox provides a flexible simulation toolkit that
% can scope with a variety of different applications.  It is written such
% that new features, such as calculation of higher harmonic generation or
% optical nearfield excitations, can be implemented without too much
% effort.
%
% We have not tested exhaustively our toolbox against other approaches,
% such as the discrete dipole approximation (DDA), the Green's dyadic, or
% the finite difference time domain (FDTD) schemes.
%
%% Applicability of the BEM approach
%
% In the BEM approach the particle boundary has to be discretized by
% boundary elements.  The discretization should be sufficiently fine at
% sharp edges or corners of the nanoparticles, such that the surface
% charges and currents can be resolved by the discretized boundary.
%
% Another important relation is |n'kd << 1|, where |n'| is the real part of
% the refractive index, |k| the wavenumber of light in vacuum, and |d| the
% extension of the boundary elements.  In the DDA approach, the authors
% suggest a limit ||n|kd < 0.5| to get reliable results, which is probably
% also a reasonable value for our BEM scheme.  Note that in contrast to
% DDA, the BEM criterion involves the real part of the refractive index,
% metals with a small skin depth in comparison to the boundary elements
% should not provide a major difficulty for the MNPBEM toolbox.

%% What to do when something goes wrong
%
% The toolbox has been developed and used over several years, and is
% expected to work properly in most cases.  Nevertheless, it can happen
% that under certain circumstances the program produces a runtime error or
% the results do not look like as they should.  If this is the case, we
% advice you to check carefully the help pages to find out whether you did
% something wrong, which usually the case.  In <bem_ug_troubleshooting.html
% trouble shooting> we have collected the most frequent problems.  Only
% when you are sure that this is not the case, we ask you to send us a
% working program together with a most detailed description of what went
% wrong, so that we can investigate the reasons for the failure.
%
%
% Copyright 2017 Ulrich Hohenester