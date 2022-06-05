function ext = extinction( obj, enei, pol )
%  Extinction - Extinction cross section for miegans objects.
%
%  Usage for obj = miegans :
%    ext = extinction( obj, enei, pol )
%  Input
%    enei       :  wavelength of light in vacuum
%    pol        :  light polarization

ext = scattering( obj, enei, pol ) + absorption( obj, enei, pol );