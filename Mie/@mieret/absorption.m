function abs = absorption( obj, enei )
%  ABSORPTION - Absorption cross section for mieret objects.
%
%  Usage for obj = mieret :
%    abs = absorption( obj, enei )
%  Input
%    enei       :  wavelength of light in vacuum

abs = extinction( obj, enei ) - scattering( obj, enei );
