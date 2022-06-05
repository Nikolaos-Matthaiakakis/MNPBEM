function vec = afun( obj, vec )
%  AFUN - Matrix multiplication for CGS, BICGSTAB, GMRES.
%
%  See Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015).

%  split vector array
[ sig1, h1par, h1perp, sig2, h2par, h2perp ] = unpack( obj, vec );

%  extract input
[ k, nvec, eps1, eps2 ] = deal( obj.k, obj.nvec, obj.eps1, obj.eps2 );
%  parallel and perpendicular components of NVEC
[ npar, nperp ] = deal( nvec( :, 1 : 2 ), nvec( :, 3 ) );
%  Green functions
[ G1, H1, G2, H2 ] = deal( obj.G1, obj.H1, obj.G2, obj.H2 );

%  modify MATMUL
matmul = @( a, b ) reshape( a * reshape( b, size( b, 1 ), [] ), size( b ) );

%  apply Green functions to surface charges 
Gsig1 = G1 * sig1;  Gsig2 = G2.ss * sig2 + G2.sh * h2perp;
Hsig1 = H1 * sig1;  Hsig2 = H2.ss * sig2 + H2.sh * h2perp;
%  apply Green functions to parallel surface currents
Gh1par = matmul( G1, h1par );  Gh2par = matmul( G2.p, h2par );
Hh1par = matmul( H1, h1par );  Hh2par = matmul( H2.p, h2par );
%  apply Green functions to perpendicular surface currents
Gh1perp = G1 * h1perp;  Gh2perp = G2.hh * h2perp + G2.hs * sig2;
Hh1perp = H1 * h1perp;  Hh2perp = H2.hh * h2perp + H2.hs * sig2;

%  Eq. (7a)
phi = Gsig1 - Gsig2;
%  Eqs. (7b,c)
apar = Gh1par - Gh2par;
aperp = Gh1perp - Gh2perp;

mul = @( x, y ) bsxfun( @times, x, y );
%  Eqs. (8a,b)
alphapar = Hh1par - Hh2par -  ...
  1i * k * ( outer( npar, Gsig1, eps1 ) - outer( npar, Gsig2, eps2 ) );
alphaperp = Hh1perp - Hh2perp -  ...
  1i * k * ( mul( Gsig1, eps1 .* nperp ) - mul( Gsig2, eps2 .* nperp ) );
%  Eq. (9)
De = mul( Hsig1, eps1 ) - mul( Hsig2, eps2 )  -  ...
  1i * k * ( inner( npar, Gh1par, eps1 ) - inner( npar, Gh2par, eps2 ) ) -  ...
  1i * k * ( mul( Gh1perp, eps1 .* nperp ) - mul( Gh2perp, eps2 .* nperp ) );

%  pack into single vector
vec = pack( obj, phi, apar, aperp, De, alphapar, alphaperp );
