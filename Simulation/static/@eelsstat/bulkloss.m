function pbulk = bulkloss( obj, enei )
%  BULKLOSS - EELS bulk loss probability in (1/eV).
%
%  See F. J. Garcia de Abajo, Rev. Mod. Phys. 82, 209 (2010), Eq. (19).
%
%  Usage for obj = eelsstat :
%    pbulk = bulkloss( obj, enei, phiout )
%  Input
%    enei     :  wavelength of light in vacuum
%  Output
%    pbulk  :  loss probability from bulk material

%  load atomic units
misc.atomicunits;
%  photon energy
ene = eV2nm / enei;
%  rest mass of electron in eV
mass = 0.51e6;

%  table of dielectric function
eps = cellfun( @( eps ) ( eps( enei ) ), obj.p.eps );
%  bulk losses [Eq. (17)]
pbulk = 2 * fine ^ 2 / ( bohr * hartree * pi * obj.vel ^ 2 ) *  ...
  imag( - 1 ./ eps ) * path( obj ) *                            ...
  log( sqrt( ( mass / ene ) ^ 2 * obj.vel ^ 2 * obj.phiout ^ 2 + 1 ) );
