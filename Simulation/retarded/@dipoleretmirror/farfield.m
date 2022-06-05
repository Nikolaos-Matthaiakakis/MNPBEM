function f = farfield( obj, varargin )
%  FARFIELD - Electromagnetic fields of dipoles in the far-field limit.
%    
%  Usage for obj = dipoleretmirror :
%    field = farfield( obj, spec, enei )
%  Input
%    spec   :  SPECTRUMRET object 
%    enei   :  wavelength of light in vacuum
%  Output
%    field  :  compstruct object that holds far-fields

f = farfield( obj.dip, varargin{ : } );
