function abs = absorption( field, infield )
%  ABSORPTION - Absorption cross section from electromagnetic fields.
%
%  Usage  :
%    abs = absorption( field, infield )
%  Input
%    field      :  compstruct object with scattered electromagnetic fields
%    infield    :  compstruct object with incoming  electromagnetic fields
%  Output
%    abs        :  absorption cross section

abs = extinction( field, infield ) - scattering( field );
