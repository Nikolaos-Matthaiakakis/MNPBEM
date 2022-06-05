function f = farfield( obj, varargin )
%  FARFIELD - Electromagnetic fields of dipoles in the far-field limit.
%    
%  Usage for obj = dipolestatmirror :
%    field = farfield( obj, spec, enei )
%  Input
%    spec   :  SPECTRUMSTAT object 
%    enei   :  wavelength of light in vacuum
%  Output
%    field  :  compstruct object that holds far-fields

f = farfield( obj.dip, varargin{ : } );