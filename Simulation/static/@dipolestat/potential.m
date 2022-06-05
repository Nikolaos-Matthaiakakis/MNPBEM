function exc = potential( obj, p, enei )
%  POTENTIAL - Potential of dipole excitation for use in bemstat.
%
%  Usage for obj = dipolestat :
%    exc = potential( obj, p, enei )
%  Input
%    p          :  points or particle surface where potential is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct array which contains the surface derivative
%                  'phip' of the scalar potential, the last two dimensions
%                  of phip correspond to the positions and dipole moments

%  electric field
exc = field( obj, p, enei );
%  surface derivative of scalar potential
exc = compstruct( p, enei, 'phip', - inner( p.nvec, exc.e ) );
