function exc = field( obj, p, enei )
%  Electric field for dipole excitation.
%
%  Usage for obj = dipolestatmirror :
%    exc = field( obj, enei )
%  Input
%    p          :  points or particle surface where field is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct object which contains the electric field, 
%                  the last two dimensions of exc.e correspond to the 
%                  positions and dipole moments

exc = field( obj.dip, p, enei );