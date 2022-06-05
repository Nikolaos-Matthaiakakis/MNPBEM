function ext = extinction( obj, enei )
%  Extinction - Extinction cross section for miestat objects.
%
%  Usage for obj = miestat :
%    ext = extinction( obj, enei )
%  Input
%    enei       :  wavelength of light in vacuum

ext = scattering( obj, enei ) + absorption( obj, enei );