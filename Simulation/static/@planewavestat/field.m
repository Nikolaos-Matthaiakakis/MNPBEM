function exc = field( obj, p, enei )
%  Electric field for plane wave excitation.
%
%  Usage for obj = planewavestat :
%    exc = field( obj, p, enei )
%  Input
%    p          :  points or particle surface where field is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct object which contains the electric field

exc = compstruct( p, enei, 'e', repmat(  ...
  reshape( obj.pol, [ 1, size( obj.pol' ) ] ), [ p.n, 1, 1 ] ) );
