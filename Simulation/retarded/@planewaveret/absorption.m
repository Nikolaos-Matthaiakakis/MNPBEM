function abs = absorption( obj, sig )
%  ABSORPTION - Absorption cross section for plane wave excitation.
%
%  Usage for obj = planewaveret :
%    abs = absorption( obj, sig )
%  Input
%    sig        :  compstruct object containing surface currents
%  Output
%    abs        :  absorption cross section

abs = extinction( obj, sig ) - scattering( obj, sig );
