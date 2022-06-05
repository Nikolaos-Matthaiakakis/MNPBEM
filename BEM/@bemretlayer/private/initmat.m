function obj = initmat( obj, enei )
%  INITMAT - Initialize matrices for BEM solver.
%    see Waxenegger et al., Comp. Phys. Commun. 193, 128 (2015).
    
%  use previously computed matrices ?
if isempty( obj.enei ) || obj.enei ~= enei
        
  %  save wavelength
  obj.enei = enei;
  %  initialize reflected Green functions
  obj.g = initrefl( obj.g, enei );
  
  %  Green functions for inner surfaces
  G1 = obj.g{ 1, 1 }.G(  enei ) - obj.g{ 2, 1 }.G(  enei );
  H1 = obj.g{ 1, 1 }.H1( enei ) - obj.g{ 2, 1 }.H1( enei );
  %  Green functions for outer surfaces
  G2 = obj.g{ 2, 2 }.G(  enei );  g2 = obj.g{ 1, 2 }.G(  enei );
  H2 = obj.g{ 2, 2 }.H2( enei );  h2 = obj.g{ 1, 2 }.H2( enei );
  %  add mixed contributions
  G2.ss = G2.ss - g2;  G2.hh = G2.hh - g2;  G2.p = G2.p - g2;
  H2.ss = H2.ss - h2;  H2.hh = H2.hh - h2;  H2.p = H2.p - h2;
  
  %  wavelength of light in vacuum
  k = 2 * pi / enei;
  %  dielectric functions
  [ eps1, eps2 ] = deal( obj.p.eps1( enei ), obj.p.eps2( enei ) );
  %  simplify for unique dielectric functions
  if numel( unique( eps1 ) ) == 1 && numel( unique( eps2 ) ) == 1 
    [ eps1, eps2 ] = deal( eps1( 1 ), eps2( 2 ) );
  else
    [ eps1, eps2 ] = deal( spdiag( eps1 ), spdiag( eps2 ) );
  end
  %  difference of dielectric functions
  deps = ( eps1 - eps2 );
  
  %  inverse of G1 and of parallel component
  G1i  = inv( G1   );
  G2pi = inv( G2.p );
  %  Sigma matrices [ Eq.(21) ]
  Sigma1  = H1   * G1i;
  Sigma2p = H2.p * G2pi;
  
  %  normal vectors
  nvec = obj.p.nvec;
  %  perpendicular and parallel component
  nperp = nvec( :, 3 );
  npar  = nvec - nperp * [ 0, 0, 1 ];   
  %  Gamma matrix
  Gamma = inv( Sigma1 - Sigma2p );
  Gammapar = 1i * k * deps * Gamma .* ( npar * npar' );
  
  %  set up full matrix, Eq. (10)
  m{ 1, 1 } = eps1 * Sigma1 * G2.ss - eps2 * H2.ss -  ...
    1i * k * ( Gammapar * deps * G2.ss + bsxfun( @times, deps * G2.hs, nperp ) );
  m{ 1, 2 } = eps1 * Sigma1 * G2.sh - eps2 * H2.sh -  ...
    1i * k * ( Gammapar * deps * G2.sh + bsxfun( @times, deps * G2.hh, nperp ) );  
  m{ 2, 1 } = Sigma1 * G2.hs - H2.hs - 1i * k * bsxfun( @times, deps * G2.ss, nperp );
  m{ 2, 2 } = Sigma1 * G2.hh - H2.hh - 1i * k * bsxfun( @times, deps * G2.sh, nperp );
  
  %  save matrices
  obj.k      = k;       %  wavenumber of light in vacuum
  obj.nvec   = nvec;    %  outer surface normals of discretized surface
  obj.npar   = npar;    %  parallel component of outer surface normal
  obj.eps1   = eps1;    %  dielectric function inside of surface
  obj.eps2   = eps2;    %  dielectric function outside of surface
  obj.G1i    = G1i;     %  inverse of  inside Green function G1
  obj.G2pi   = G2pi;    %  inverse of outside parallel Green function G2
  obj.G2     = G2;      %  outside Green function G2
  obj.H2     = H2;      %  outside surface derivative of Green function G2
  obj.Sigma1 = Sigma1;  %  H1 * G1i, Eq. (21)
  obj.Gamma  = Gamma;   %  inv( Sigma1 - Sigma2 )
  obj.m      = m;       %  response matrix for layer system

end
