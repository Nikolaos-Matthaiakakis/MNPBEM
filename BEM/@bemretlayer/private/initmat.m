function obj = initmat( obj, enei )
%  INITMAT - Initialize matrices for BEM solver.
%    see Waxenegger et al., Comp. Phys. Commun. 193, 128 (2015).
    
%  use previously computed matrices ?
if isempty( obj.enei ) || obj.enei ~= enei
        
  %  save wavelength
  obj.enei = enei;
  %  initialize reflected Green functions
  obj.g = initrefl( obj.g, enei );
  
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
  
  %%  Green functions
  %  Green functions for inner surfaces
  G11 = obj.g{ 1, 1 }.G(  enei );  G21 = obj.g{ 2, 1 }.G(  enei );
  H11 = obj.g{ 1, 1 }.H1( enei );  H21 = obj.g{ 2, 1 }.H1( enei );
  %  mixed contributions
  G1 = G11 - G21;  G1e = eps1 * G11 - eps2 * G21;
  H1 = H11 - H21;  H1e = eps1 * H11 - eps2 * H21;
  clear G11 G21 H11 H22
  
  %  Green functions for outer surfaces
  G22 = obj.g{ 2, 2 }.G(  enei );  G12 = obj.g{ 1, 2 }.G(  enei );
  H22 = obj.g{ 2, 2 }.H2( enei );  H12 = obj.g{ 1, 2 }.H2( enei );
  %  mixed contributions
  G2.ss = G22.ss - G12;  G2e.ss = eps2 * G22.ss - eps1 * G12;
  G2.hh = G22.hh - G12;  G2e.hh = eps2 * G22.hh - eps1 * G12;
  G2.p  = G22.p  - G12;  G2e.p  = eps2 * G22.p  - eps1 * G12;
  G2.sh = G22.sh;        G2e.sh = eps2 * G22.sh;
  G2.hs = G22.hs;        G2e.hs = eps2 * G22.hs;
  
  H2.ss = H22.ss - H12;  H2e.ss = eps2 * H22.ss - eps1 * H12;
  H2.hh = H22.hh - H12;  H2e.hh = eps2 * H22.hh - eps1 * H12;
  H2.p  = H22.p  - H12;  H2e.p  = eps2 * H22.p  - eps1 * H12;
  H2.sh = H22.sh;        H2e.sh = eps2 * H22.sh;
  H2.hs = H22.hs;        H2e.hs = eps2 * H22.hs;  
  clear G22 G12 H22 H21
  
  %%  auxiliary matrices
  %  inverse of G1 and of parallel component
  G1i  = inv( G1   );  
  G2pi = inv( G2.p ); 
  %  Sigma matrices [ Eq.(21) ]
  Sigma1  = H1   * G1i;
  Sigma1e = H1e  * G1i;
  Sigma2p = H2.p * G2pi;
  %  auxiliary dielectric function matrices
  L1  = G1e   * G1i;  
  L2p = G2e.p * G2pi;
  
  %  normal vectors
  nvec = obj.p.nvec;
  %  perpendicular and parallel component
  nperp = nvec( :, 3 );
  npar  = nvec - nperp * [ 0, 0, 1 ];   
  %  Gamma matrix
  Gamma = inv( Sigma1 - Sigma2p );
  Gammapar = 1i * k * ( L1 - L2p ) * Gamma .* ( npar * npar' );
  
  %  set up full matrix, Eq. (10)
  m{ 1, 1 } = Sigma1e * G2.ss - H2e.ss - 1i * k *  ...
    ( Gammapar * ( L1 * G2.ss - G2e.ss ) + bsxfun( @times, L1 * G2.sh - G2e.sh, nperp ) );
  m{ 1, 2 } = Sigma1e * G2.sh - H2e.sh - 1i * k *  ...
    ( Gammapar * ( L1 * G2.sh - G2e.sh ) + bsxfun( @times, L1 * G2.hh - G2e.hh, nperp ) );  
  m{ 2, 1 } = Sigma1 * G2.hs - H2.hs - 1i * k * bsxfun( @times, L1 * G2.ss - G2e.ss, nperp );
  m{ 2, 2 } = Sigma1 * G2.hh - H2.hh - 1i * k * bsxfun( @times, L1 * G2.sh - G2e.sh, nperp );
  
  %%  save matrices
  obj.k       = k;       %  wavenumber of light in vacuum
  obj.nvec    = nvec;    %  outer surface normals of discretized surface
  obj.npar    = npar;    %  parallel component of outer surface normal
  obj.eps1    = eps1;    %  dielectric function inside of surface
  obj.eps2    = eps2;    %  dielectric function outside of surface
  obj.L1      = L1;      %  G1e * inv( G1 )
  obj.L2p     = L2p;     %  G2e * inv( G2 ), parallel component
  obj.G1i     = G1i;     %  inverse of  inside Green function G1
  obj.G2pi    = G2pi;    %  inverse of outside parallel Green function G2
  obj.G2      = G2;      %  outside Green function G2
  obj.G2e     = G2e;     %  G2 multiplied with dielectric function
  obj.Sigma1  = Sigma1;  %  H1 * G1i, Eq. (21)
  obj.Sigma1e = Sigma1e; %  H1e * G1i, Eq. (21)
  obj.Gamma   = Gamma;   %  inv( Sigma1 - Sigma2 )
  obj.m       = m;       %  response matrix for layer system

end
