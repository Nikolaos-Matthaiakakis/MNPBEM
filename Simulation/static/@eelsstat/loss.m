function [ psurf, pbulk ] = loss( obj, sig )
%  LOSS - EELS loss probability in (1/eV).
%
%  See F. J. Garcia de Abajo & J. Aiizpura, Phys. Rev. 56, 15873 (1997). 
%
%  Usage for obj = eelsstat :
%    [ psurf, pbulk ] = loss( obj, sig )
%  Input
%    sig      :  surface charge (from bemstat)
%  Output
%    psurf    :  EELS loss probability from surface plasmons
%    pbulk    :  loss probability from bulk material

%  wavenumber of electron beam
q = 2 * pi / ( sig.enei * obj.vel );
%  potential for infinite beam
phi = potinfty( obj, q, 1 );

%  load atomic units
misc.atomicunits;
%  surface plasmon loss [Eq. (18)]
psurf = - fine ^ 2 / ( bohr * hartree * pi ) *  ...
  imag( sig.p.area' * ( conj( phi ) .* sig.sig ) );
%  bulk losses [Eq. (17)]
pbulk = bulkloss( obj, sig.enei );
