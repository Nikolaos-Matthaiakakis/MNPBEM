function abs = absorption( obj, sig )
%  ABSORPTION - Absorption cross section for plane wave excitation.
%
%  Usage for obj = planewaveretlayer :
%    abs = absorption( obj, sig )
%  Input
%    sig        :  compstruct object containing surface currents
%  Output
%    abs        :  absorption cross section

%  (note) this equation only works for non-absorbing layer materials
abs = extinction( obj, sig ) - scattering( obj, sig );
