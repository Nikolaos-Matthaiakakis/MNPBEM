function exc = field( obj, p, enei )
%  Electric field for plane wave excitation.
%
%  Usage for obj = planewavestatmirror :
%    exc = field( obj, p, enei )
%  Input
%    p          :  points or particle surface where field is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct object which contains the electric field

exc = field( obj.exc, p, enei );
