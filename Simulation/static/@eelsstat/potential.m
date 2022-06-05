function exc = potential( obj, enei )
%  POTENTIAL - Potential of electron beam excitation for use in bemstat.
%
%  See F. J. Garcia de Abajo & J. Aiizpura, Phys. Rev. 56, 15873 (1997). 
%
%  Usage for obj = eelsstat :
%    exc = potential( obj, enei )
%  Input
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  COMPSTRUCT object which contains the scalar potentials
%                  and surface derivatives

%  wavenumber of electron beam
q = 2 * pi / ( enei * obj.vel );

%  potential and surface derivative for infinite beam
[ phi, phip ] = potinfty( obj, q, 1 );
%  potential and surface derivative for beam inside of material
[ pin, pinp ] = potinside( obj, q, 0 );

%  table of dielectric function
eps = cellfun( @( eps ) ( eps( enei ) ), obj.p.eps );
%  difference of inverse dielectric functions
ideps =  1 ./ eps - 1 / eps( 1 );

%  add potential from beam inside of particle
phi  = phi  / eps( 1 ) + full( obj, pin  * diag( ideps( obj.indmat ) ) );
phip = phip / eps( 1 ) + full( obj, pinp * diag( ideps( obj.indmat ) ) );

%  external excitation
exc = compstruct( obj.p, enei, 'phi', phi, 'phip', phip );
