function pbulk = bulkloss( obj, enei )
%  BULKLOSS - EELS bulk loss probability in (1/eV).
%
%  See F. J. Garcia de Abajo, Rev. Mod. Phys. 82, 209 (2010), Eq. (18).
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
%  wavenumber of electron beam
q = 2 * pi / ( enei * obj.vel );
%  cutoff wavenumber
qc = q * sqrt( ( mass / ene ) ^ 2 * obj.vel ^ 2 * obj.phiout ^ 2 + 1 );
%  wavenumber of light in media
k = 2 * pi / enei * sqrt( eps );


%  bulk losses [Eq. (18)]
pbulk = fine ^ 2 / ( bohr * hartree * pi * obj.vel ^ 2 ) *  ...
    imag( ( obj.vel ^ 2 - 1 ./ eps ) .*                     ...
          log( ( qc ^ 2 - k .^ 2 ) ./ ( q ^ 2 - k .^ 2 ) ) ) * path( obj );
