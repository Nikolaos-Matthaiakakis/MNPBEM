function obj = initmat( obj, enei )
%  Initialize matrices for BEM solver.
    
%  use previously computed matrices ?
if isempty( obj.enei ) || obj.enei ~= enei
        
  obj.enei = enei;

  %%  auxiliary quantities
  %  outer surface normals
  nvec = obj.p.nvec;
  %  wavenumber
  k = 2 * pi / enei;

  %%  dielectric functions
  eps1 = spdiag( obj.p.eps1( enei ) );
  eps2 = spdiag( obj.p.eps2( enei ) );

  %  simplify for unique dielectric functions
  if length( unique( diag( eps1 ) ) ) == 1 &&   ...
     length( unique( diag( eps2 ) ) ) == 1 
    eps1 = full( eps1( 1 ) );
    eps2 = full( eps2( 1 ) );
  end
 
  %%  Green functions and surface derivatives
  G1 = obj.g{ 1, 1 }.G( enei ) - obj.g{ 2, 1 }.G( enei );  G1i = inv( G1 );
  G2 = obj.g{ 2, 2 }.G( enei ) - obj.g{ 1, 2 }.G( enei );  G2i = inv( G2 );

  H1 = obj.g{ 1, 1 }.H1( enei ) - obj.g{ 2, 1 }.H1( enei );
  H2 = obj.g{ 2, 2 }.H2( enei ) - obj.g{ 1, 2 }.H2( enei );

  %%  L matrices [ Eq. (22) ]
  %    depending on the connectivity matrix, L1 and L2 can be
  %    full matrices, diagonal matrices, or scalars
  if all( obj.g.con{ 1, 2 } == 0 )
    L1 = eps1;
    L2 = eps2;
  else
    L1 = G1 * eps1 * G1i;
    L2 = G2 * eps2 * G2i; 
  end
  
  %%  Sigma and Delta matrices, and combinations
  %  Sigma matrices [ Eq.(21) ]
  Sigma1 = H1 * G1i;  clear G1 H1;
  Sigma2 = H2 * G2i;  clear G2 H2;
   
  %  inverse Delta matrix
  Deltai = inv( Sigma1 - Sigma2 );
   
  %  difference of dielectric functions
  L = L1 - L2;
  %  Sigma matrix
  Sigma = Sigma1 * L1 - Sigma2 * L2 +  ...
      k ^ 2 * ( ( L * Deltai ) .* ( nvec * nvec' ) ) * L;

  clear L Sigma2;
  
  %%  save everything in class

  obj.k =  k;           %  wavenumber of light in vacuum
  obj.nvec = nvec;      %  outer surface normals of discretized surface
  obj.eps1 = eps1;      %  dielectric function  inside of surface
  obj.eps2 = eps2;      %  dielectric function outside of surface
  obj.G1i = G1i;        %  inverse of  inside Green function G1
  obj.G2i = G2i;        %  inverse of outside Green function G2
  obj.L1  = L1;                 %  G1 * eps1 * G1i, Eq. (22)
  obj.L2  = L2;                 %  G2 * eps2 * G2i
  obj.Sigma1 = Sigma1;          %  H1 * G1i, Eq. (21)
  obj.Deltai = Deltai;          %  inv( Sigma1 - Sigma2 ) 
  obj.Sigmai = inv( Sigma );    %  Eq. (21,22)

end
