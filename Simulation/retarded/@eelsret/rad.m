function [ prad, dprad ] = rad( obj, sig )
%  RAD - Photon loss probability.
%
%  See Garcia de Abajo et al., PRB 65, 115418 (2002), RMP 82, 209 (2010).
%
%  Usage for obj = eelsret :
%    [ prad, dprad ] = loss( obj, sig )
%  Input
%    sig    :  surface charge (from bemret)
%  Output
%    prad   :  photon loss probability, see RMP Sec. IV.2.B
%    dprad  :  differential cross section

%  compute far fields at infinity
field = farfield( obj.spec, sig );
%  scattering and differential cross section
[ sca, dsca ] = scattering( field );

%  load atomic units
misc.atomicunits;
%  wavenumber of light in embedding medium
[ ~, k ] = sig.p.eps{ obj.spec.medium }( sig.enei );
%  photon loss probability
%    (fixme) prefactor seems to be fine but has not been checked properly
 prad = fine ^ 2 / ( 2 * pi ^ 2 * hartree * bohr * k ) *  sca;
dprad = fine ^ 2 / ( 2 * pi ^ 2 * hartree * bohr * k ) * dsca;
%  convert differential radiated power to compstruct object
dprad = compstruct( obj.spec.pinfty, field.enei, 'dprad', dprad );