function ext = extinction( obj, sig )
%  EXTINCTION - Extinction cross section for plane wave excitation.
%
%  Usage for obj = planewavestat :
%    abs = extinction( obj, sig )
%  Input
%    sig        :  compstruct object containing surface charge
%  Output
%    ext        :  extinction cross section

ext = scattering( obj, sig ) + absorption( obj, sig );
