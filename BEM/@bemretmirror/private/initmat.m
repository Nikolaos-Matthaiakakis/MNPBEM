function obj = initmat( obj, enei )
%  INITMAT - Initialize matrices for BEM solver.
    
%  use previously computed matrices ? 
if isempty( obj.enei ) || obj.enei ~= enei
        
  obj.enei = enei;

  %  surface normals
  nvec = obj.p.nvec;
  %  wavenumber
  k = 2 * pi / enei;

  %  dielectric functions
  eps1 = spdiag( obj.p.eps1( enei ) );
  eps2 = spdiag( obj.p.eps2( enei ) );

  %  simplify for unique dielectric functions
  if length( unique( diag( eps1 ) ) ) == 1 &&   ...
     length( unique( diag( eps2 ) ) ) == 1 
    eps1 = full( eps1( 1 ) );
    eps2 = full( eps2( 1 ) );
  end
 
  %  Green functions and surface derivatives
  G1 = subtract( obj.g{ 1, 1 }.G( enei ), obj.g{ 2, 1 }.G( enei ) ); 
  G2 = subtract( obj.g{ 2, 2 }.G( enei ), obj.g{ 1, 2 }.G( enei ) ); 
  
  G1i = cellfun( @( g ) ( inv( g ) ), G1, 'UniformOutput', false );
  G2i = cellfun( @( g ) ( inv( g ) ), G2, 'UniformOutput', false );

  H1 = subtract( obj.g{ 1, 1 }.H1( enei ), obj.g{ 2, 1 }.H1( enei ) );
  H2 = subtract( obj.g{ 2, 2 }.H2( enei ), obj.g{ 1, 2 }.H2( enei ) );

  %  loop over symmetry values  
  for i = 1 : length( G1 )  
    
  %  L matrices [ Eq. (22) ]
  %    depending on the connectivity matrix, L1 and L2 can be
  %    full matrices, diagonal matrices, or scalars
    if all( obj.g.con{ 1, 2 } == 0 )
      L1{ i } = eps1;
      L2{ i } = eps2;
    else
      L1{ i } = G1{ i } * eps1 * G1i{ i };
      L2{ i } = G2{ i } * eps2 * G2i{ i };
    end
  
    %  Sigma matrices [ Eq.(21) ]
    Sigma1{ i } = H1{ i } * G1i{ i };
    Sigma2{ i } = H2{ i } * G2i{ i };
    %  inverse Delta matrix
    Deltai{ i } = inv( Sigma1{ i } - Sigma2{ i } );    
  end
  
  %  save everything in class

  obj.k    = k;         %  wavenumber of light in vacuum
  obj.nvec = nvec;      %  outer surface normals of discretized surface
  obj.eps1 = eps1;      %  dielectric function  inside of surface
  obj.eps2 = eps2;      %  dielectric function outside of surface
  obj.G1i  = G1i;       %  inverse of  inside Green function G1
  obj.G2i  = G2i;       %  inverse of outside Green function G2
  obj.L1   = L1;                %  G1 * eps1 * G1i, Eq. (22)
  obj.L2   = L2;                %  G2 * eps2 * G2i
  obj.Sigma1 = Sigma1;          %  H1 * G1i, Eq. (21)
  obj.Sigma2 = Sigma2;          %  H2 * G2i, Eq. (21)  
  obj.Deltai = Deltai;          %  inv( Sigma1 - Sigma2 ) 
  obj.Sigmai = cell(4,4,4);     %  Eq. (21,22), computed in initsigmai
end


function c = subtract( a, b )
%  SUBTRACT - Subtract cell arrays.

if ~iscell( a )
  c = cellfun( @( b ) a - b, b, 'UniformOutput', false );
else
  c = cellfun( @( a, b ) a - b, a, b, 'UniformOutput', false );
end  

