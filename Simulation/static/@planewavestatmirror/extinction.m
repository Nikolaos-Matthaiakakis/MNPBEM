function ext = extinction( obj, sig )
%  EXTINCTION - Extinction cross section for plane wave excitation.
%
%  Usage for obj = planewavestatmirror :
%    abs = extinction( obj, sig )
%  Input
%    sig        :  compstructmirror object containing surface charge
%  Output
%    ext        :  extinction cross section

ext = extinction( obj.exc, full( obj, sig ) );
