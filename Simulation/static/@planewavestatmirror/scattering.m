function sca = scattering( obj, sig )
%  SCATTERING - Scattering cross section for plane wave excitation.
%
%  Usage for obj = planewavestatmirror :
%    sca = scattering( obj, sig )
%  Input
%    sig        :  COMPSTRUCTMIRROR object containing surface charge
%  Output
%    sca        :  scattering cross section

sca = scattering( obj.exc, full( obj, sig ) );