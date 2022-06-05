function phi = mtimes( obj, sig )
%  Induced potential for given surface charge.
%
%  Usage for obj = bemstatmirror :
%    phi = obj * sig
%  Input
%    sig    :  surface charge
%  Output
%    phi    :  induced potential

phi  = potential( obj, sig, 1 );
phi2 = potential( obj, sig, 2 );

for i = 1 : length( sig )
  phi{ i } = phi{ i } + phi2{ i };
end
