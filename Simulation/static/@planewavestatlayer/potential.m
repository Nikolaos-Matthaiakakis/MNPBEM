function exc = potential( obj, p, enei )
%  POTENTIAL - Potential of plane wave excitation for use in BEMSTATLAYER.
%
%  Usage for obj = planewavestatlayer :
%    exc = potential( obj, p, enei )
%  Input
%    p          :  points or particle surface where potential is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct array which contains the surface derivative
%                  'phip' of the scalar potential

%  compute electric field
e = subsref( field( obj, p, enei ), substruct( '.', 'e' ) );
%  excitation structure
exc = compstruct( p, enei, 'phip', - inner( p.nvec, e ) );
