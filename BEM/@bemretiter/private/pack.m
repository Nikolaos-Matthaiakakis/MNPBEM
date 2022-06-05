function vec = pack( ~, phi, a, phip, ap )
%  PACK - Pack scalar and vector potentials into single vector.

vec = [ phi( : ); a( : ); phip( : ); ap( : ) ];
