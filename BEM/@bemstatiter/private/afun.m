function vec = afun( obj, vec )
%  AFUN - Matrix multiplication for CGS, BICGSTAB, GMRES.

%  unpack vector
vec = reshape( vec, obj.p.n, [] );
%  - ( lambda + F ) * vec
vec = - ( obj.F * vec + bsxfun( @times, vec, obj.lambda( : ) ) );
vec = reshape( vec, [], 1 );
