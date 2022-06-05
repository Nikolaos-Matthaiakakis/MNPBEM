function phi = mtimes( obj, sig )
%  MTIMES - Induced potential for given surface charge.
%
%  Usage for obj = bemretmirror :
%    phi = obj * sig
%  Input
%    sig    :  COMPSTRUCTMIRROR with fields for surface charges and currents
%  Output
%    phi    :  COMPSTRUCTMIRROR with fields for induced potential

phi  = potential( obj, sig, 1 );
phi2 = potential( obj, sig, 2 );

for i = 1 : length( sig )
  phi{ i } = phi{ i } + phi2{ i };
end
