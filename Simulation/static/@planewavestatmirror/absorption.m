function abs = absorption( obj, sig )
%  ABSORPTION - Absorption cross section for plane wave excitation.
%
%  Usage for obj = planewavestatmirror :
%    abs = absorption( obj, sig )
%  Input
%    sig        :  compstructmirror object containing surface charge
%  Output
%    abs        :  absorption cross section

abs = absorption( obj.exc, full( obj, sig ) );