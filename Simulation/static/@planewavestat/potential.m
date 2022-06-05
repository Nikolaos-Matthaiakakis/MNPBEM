function exc = potential( obj, p, enei )
%  POTENTIAL - Potential of plane wave excitation for use in bemstat.
%
%  Usage for obj = planewavestat :
%    exc = potential( obj, p, enei )
%  Input
%    p          :  points or particle surface where potential is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct array which contains the surface derivative
%                  'phip' of the scalar potential

exc = compstruct( p, enei, 'phip', - p.nvec * transpose( obj.pol ) );