%% Planewave excitation examples
%
% <<../figures/mnpbemlogo.jpg>>
%
% The runtimes of the following programs are given for my not overly fast
% office computer (Intel i7-2600 CPU, 3.40 GHz, 8 GB RAM).
%
%% Quasistatic planewave excitation examples
%
% * <matlab:edit('demospecstat1.m') demospecstat1.m> - 
% Light scattering of metallic nanosphere (2 sec).
% <matlab:beminfo('demospecstat1.m') info>, 
% <matlab:eval('demospecstat1') run>
% * <matlab:edit('demospecstat2.m') demospecstat2.m> - 
% Light scattering of metallic nanoellipsoid (4 sec).
% <matlab:beminfo('demospecstat2.m') info>, 
% <matlab:eval('demospecstat2') run>
% * <matlab:edit('demospecstat3.m') demospecstat3.m> - 
% Light scattering of coated metallic sphere (16 sec).
% <matlab:beminfo('demospecstat3.m') info>, 
% <matlab:eval('demospecstat3') run>
% * <matlab:edit('demospecstat4.m') demospecstat4.m> - 
% Field enhancement for coated metallic sphere (8 sec).
% <matlab:beminfo('demospecstat4.m') info>, 
% <matlab:eval('demospecstat4') run>
% * <matlab:edit('demospecstat5.m') demospecstat5.m> - 
% Light scattering of nanotriangle (5 sec).
% <matlab:beminfo('demospecstat5.m') info>, 
% <matlab:eval('demospecstat5') run>
% * <matlab:edit('demospecstat6.m') demospecstat6.m> - 
% Field enhancement for nanotriangle (7 sec).
% <matlab:beminfo('demospecstat6.m') info>, 
% <matlab:eval('demospecstat6') run>
% * <matlab:edit('demospecstat7.m') demospecstat7.m> - 
% Plasmonic eigenmodes for nanodisk (6 sec).
% <matlab:beminfo('demospecstat7.m') info>, 
% <matlab:eval('demospecstat7') run>
% * <matlab:edit('demospecstat8.m') demospecstat8.m> - 
% Light scattering of coupled nanotriangles (bowtie, 9 sec).
% <matlab:beminfo('demospecstat8.m') info>, 
% <matlab:eval('demospecstat8') run>
% * <matlab:edit('demospecstat9.m') demospecstat9.m> - 
% Field enhancement for coupled nanotriangles (bowtie, 14 sec).
% <matlab:beminfo('demospecstat9.m') info>, 
% <matlab:eval('demospecstat9') run>
%
% *Substrate*
% 
% * <matlab:edit('demospecstat10.m') demospecstat10.m> - 
% Light scattering of metallic nanosphere above substrate (4 sec).
% <matlab:beminfo('demospecstat10.m') info>, 
% <matlab:eval('demospecstat10') run>
% * <matlab:edit('demospecstat11.m') demospecstat11.m> - 
% Field enhancement for metallic sphere above substrate (4 sec).
% <matlab:beminfo('demospecstat11.m') info>, 
% <matlab:eval('demospecstat11') run>
% * <matlab:edit('demospecstat12.m') demospecstat12.m> - 
% Light scattering of nanodisk above substrate (8 sec).
% <matlab:beminfo('demospecstat12.m') info>, 
% <matlab:eval('demospecstat12') run>
% * <matlab:edit('demospecstat13.m') demospecstat13.m> - 
% Field enhancement for metallic disk above substrate (13 sec).
% <matlab:beminfo('demospecstat13.m') info>, 
% <matlab:eval('demospecstat13') run>
%
% *Mirror symmetry and iterative BEM solver*
%
% * <matlab:edit('demospecstat14.m') demospecstat14.m> - 
% Light scattering of nanosphere with mirror symmetry (2 sec).
% <matlab:beminfo('demospecstat14.m') info>, 
% <matlab:eval('demospecstat14') run>
% * <matlab:edit('demospecstat15.m') demospecstat15.m> - 
% Light scattering of nanodisk with mirror symmetry (30 sec).
% <matlab:beminfo('demospecstat15.m') info>, 
% <matlab:eval('demospecstat15') run>
% * <matlab:edit('demospecstat16.m') demospecstat16.m> - 
% Field enhancement for nanodisk with mirror symmetry (9 sec).
% <matlab:beminfo('demospecstat16.m') info>, 
% <matlab:eval('demospecstat16') run>
% * <matlab:edit('demospecstat17.m') demospecstat17.m> - 
% Light scattering of nanorod using iterative BEM solver (4 min).
% <matlab:beminfo('demospecstat17.m') info>, 
% <matlab:eval('demospecstat17') run>
% * <matlab:edit('demospecstat18.m') demospecstat18.m> - 
% Auxiliary information for iterative BEM solver (30 sec).
% <matlab:beminfo('demospecstat18.m') info>, 
% <matlab:eval('demospecstat18') run>
%
% *Nonlocal dielectric function*
%
% * <matlab:edit('demospecstat19.m') demospecstat19.m> - 
% Light scattering of nanosphere using nonlocality (5 sec).
% <matlab:beminfo('demospecstat19.m') info>, 
% <matlab:eval('demospecstat19') run>
% * <matlab:edit('demospecstat20.m') demospecstat20.m> - 
% Light scattering of coupled nanospheres using nonlocality (90 sec).
% <matlab:beminfo('demospecstat20.m') info>, 
% <matlab:eval('demospecstat20') run>
%
%% Retarded planewave excitation examples
%
% * <matlab:edit('demospecret1.m') demospecret1.m> -
% Light scattering of metallic nanosphere (7 sec).
% <matlab:beminfo('demospecret1.m') info>, 
% <matlab:eval('demospecret1') run>
% * <matlab:edit('demospecret2.m') demospecret2.m> - 
% Light scattering of metallic nanodisk (18 sec).
% <matlab:beminfo('demospecret2.m') info>, 
% <matlab:eval('demospecret3') run>
% * <matlab:edit('demospecret3.m') demospecret3.m> - 
% Field enhancement for nanodisk (20 sec).
% <matlab:beminfo('demospecret3.m') info>, 
% <matlab:eval('demospecret3') run>
% * <matlab:edit('demospecret4.m') demospecret4.m> - 
% Spectrum for Au nanosphere in Ag nanocube (2 min).
% <matlab:beminfo('demospecret4.m') info>, 
% <matlab:eval('demospecret4') run>
% * <matlab:edit('demospecret5.m') demospecret5.m> -
% Field enhancement for Au nanosphere in Ag nanocube (1 min).
% <matlab:beminfo('demospecret5.m') info>, 
% <matlab:eval('demospecret5') run>
%
% *Substrate and layer structure*
%
% * <matlab:edit('demospecret6.m') demospecret6.m> - 
% Light scattering of metallic nanosphere above substrate (36 sec).
% <matlab:beminfo('demospecret6.m') info>, 
% <matlab:eval('demospecret6') run>
% * <matlab:edit('demospecret7.m') demospecret7.m> - 
% Field enhancement of metallic nanosphere above substrate (40 sec).
% <matlab:beminfo('demospecret7.m') info>, 
% <matlab:eval('demospecret7') run>
% * <matlab:edit('demospecret8.m') demospecret8.m> - 
% Scattering spectra for metallic nanodisk on substrate (1 min).
% <matlab:beminfo('demospecret8.m') info>, 
% <matlab:eval('demospecret8') run>
% * <matlab:edit('demospecret9.m') demospecret9.m> - 
% Scattering spectra for substrate using PARFOR loop (40 sec).
% <matlab:beminfo('demospecret9.m') info>, 
% <matlab:eval('demospecret9') run>
% * <matlab:edit('demospecret10.m') demospecret10.m> - 
% Nearfield enhancement for metallic nanodisk on substrate (47 sec).
% <matlab:beminfo('demospecret10.m') info>, 
% <matlab:eval('demospecret10') run>
% * <matlab:edit('demospecret11.m') demospecret11.m> - 
% Scattering spectra for two nanospheres in layer (2 min).
% <matlab:beminfo('demospecret11.m') info>, 
% <matlab:eval('demospecret11') run>
% * <matlab:edit('demospecret12.m') demospecret12.m> - 
% Nearfield enhancement for two nanospheres in layer (1 min).
% <matlab:beminfo('demospecret12.m') info>, 
% <matlab:eval('demospecret12') run>
% * <matlab:edit('demospecret13.m') demospecret13.m> - 
% Spectra for metallic nanodisk approaching substrate (8 min).
% <matlab:beminfo('demospecret13.m') info>, 
% <matlab:eval('demospecret13') run>
% * <matlab:edit('demospecret14.m') demospecret14.m> - 
% Spectra for metallic nanodisk on top of substrate (15 min).
% <matlab:beminfo('demospecret14.m') info>, 
% <matlab:eval('demospecret14') run>
%
% *Mirror symmetry and iterative BEM solver*
%
% * <matlab:edit('demospecret15.m') demospecret15.m> - 
% Light scattering of nanosphere with mirror symmetry (13 sec).
% <matlab:beminfo('demospecret15.m') info>, 
% <matlab:eval('demospecret15') run>
% * <matlab:edit('demospecret16.m') demospecret16.m> - 
% Light scattering of nanodisk with mirror symmetry (3 min).
% <matlab:beminfo('demospecret16.m') info>, 
% <matlab:eval('demospecret16') run>
% * <matlab:edit('demospecret17.m') demospecret17.m> - 
% Light scattering of nanorod using iterative BEM solver (35 min).
% <matlab:beminfo('demospecret17.m') info>, 
% <matlab:eval('demospecret17') run>
% * <matlab:edit('demospecret18.m') demospecret18.m> - 
% Timing for iterative BEM solver (70 min).
% <matlab:beminfo('demospecret18.m') info>, 
% <matlab:eval('demospecret18') run>
% * <matlab:edit('demospecret19.m') demospecret19.m> - 
% Light scattering of sphere chain using iterative BEM solver (19 min).
% <matlab:beminfo('demospecret19.m') info>, 
% <matlab:eval('demospecret19') run>
% * <matlab:edit('demospecret20.m') demospecret20.m> - 
% Nanorod above substrate using itertive BEM solver (2 hours).
% <matlab:beminfo('demospecret20.m') info>, 
% <matlab:eval('demospecret20') run>
%
%
% Copyright 2017 Ulrich Hohenester