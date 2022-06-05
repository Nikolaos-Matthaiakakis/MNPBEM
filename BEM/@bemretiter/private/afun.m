function vec = afun( obj, vec )
%  AFUN - Matrix multiplication for CGS, BICGSTAB, GMRES.
%
%  See, e.g. Garcia de Abajo and Howie, PRB  65, 115418 (2002).

[ n, siz ] = deal( obj.p.n, numel( vec ) / 2 );
%  split vector array
vec1 = reshape( vec(         1   : siz ), n, [] );
vec2 = reshape( vec( ( siz + 1 ) : end ), n, [] );
%  multiplication with Green functions
[ Gsig1, Gh1, Gsig2, Gh2 ] = unpack( obj,  ...
  [ reshape( obj.G1 * vec1, [], 1 );  reshape( obj.G2 * vec2, [], 1 ) ] );
[ Hsig1, Hh1, Hsig2, Hh2 ] = unpack( obj,  ...
  [ reshape( obj.H1 * vec1, [], 1 );  reshape( obj.H2 * vec2, [], 1 ) ] ); 

%  extract input
[ k, nvec, eps1, eps2 ] = deal( obj.k, obj.nvec, obj.eps1, obj.eps2 );
%  modify MATMUL
matmul = @( a, b )  ...
  reshape( bsxfun( @times, a( : ), reshape( b, numel( a ), [] ) ), size( b ) );

%  Eq. (10)
phi = Gsig1 - Gsig2;
%  Eq. (11)
a = Gh1 - Gh2;

%  Eq. (14)
alpha = Hh1 - Hh2 -  ...
           1i * k * outer( nvec, matmul( eps1, Gsig1 ) - matmul( eps2, Gsig2 ) ); 
%  Eq. (17)
De = matmul( eps1, Hsig1 ) - matmul( eps2, Hsig2 ) -  ...
           1i * k * inner( nvec, matmul( eps1, Gh1 ) - matmul( eps2, Gh2 ) );
     
%  pack into single vector
vec = pack( obj, phi, a, De, alpha );
