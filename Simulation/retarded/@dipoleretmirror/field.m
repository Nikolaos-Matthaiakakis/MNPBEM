function f = field( obj, p, enei, varargin )
%  FIELD - Electromagnetic fields for dipole excitation.
%
%  Usage for obj = dipoleretmirror :
%    field = field( obj, enei, inout )
%  Input
%    p          :  points or particle surface where fields are computed
%    enei       :  light wavelength in vacuum
%    inout      :  compute field at in- or out-side of p (inout = 1 on default)
%  Output
%    field      :  compstruct object which contains the electromagnetic
%                  fields, the last two dimensions corresponding to the 
%                  positions and dipole moments

f = field( obj.dip, p, enei, varargin{ : } );