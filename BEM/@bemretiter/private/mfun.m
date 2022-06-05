function vec = mfun( obj, vec )
%  MFUN - Preconditioner for CGS, BICGSTAB, GMRES.
%
%  See Garcia de Abajo and Howie, PRB  65, 115418 (2002).

%%  external perturbation and extract stored variables
%  Garcia de Abajo and Howie, PRB 65, 115418 (2002).

%  unpack matrices
[ phi, a, De, alpha ] = unpack( obj, vec );

%  get variables for evaluation of preconditioner
sav = obj.sav;

k = sav.k;            %  wavenumber of light in vacuum
nvec = sav.nvec;      %  outer surface normals of discretized surface
G1i  = sav.G1i;       %  inverse of  inside Green function G1
G2i  = sav.G2i;       %  inverse of outside Green function G2
eps1 = sav.eps1;              %   inner dielectric function
eps2 = sav.eps2;              %  outer dielectric function
Sigma1 = sav.Sigma1;          %  H1 * G1i, Eq. (21)
Deltai = sav.Deltai;          %  inv( Sigma1 - Sigma2 ) 
Sigmai = sav.Sigmai;          %  Eq. (21,22)

%%  solve BEM equations
%  modify MATMUL (inv and LU matrices)
switch obj.precond
  case 'hmat'
    matmul1 = @( a, b ) reshape( a * reshape( b, size( b, 1 ), [] ), size( b ) );
    matmul2 = @( a, b ) reshape( solve( a, reshape( b, size( b, 1 ), [] ) ), size( b ) );
  case 'full'
    matmul1 = @( a, b ) reshape( a * reshape( b, size( b, 1 ), [] ), size( b ) );
    matmul2 = @( a, b ) reshape( a * reshape( b, size( b, 1 ), [] ), size( b ) );
end

%  modify alpha and De
alpha = alpha - matmul1( Sigma1, a ) + 1i * k * outer( nvec, eps1 * phi );
De = De - eps1 * matmul1( Sigma1, phi ) + 1i * k * eps1 * inner( nvec, a );
              
%  Eq. (19)
sig2 = matmul2( Sigmai,  ...
    De + 1i * k * ( eps1 - eps2 ) * inner( nvec, matmul1( Deltai, alpha ) ) );
%  Eq. (20)
h2 = matmul1( Deltai, 1i * k * outer( nvec, ( eps1 - eps2 ) * sig2 ) + alpha );

%%  surface charges and currents
sig1 = matmul2( G1i, sig2 + phi );   h1 = matmul2( G1i, h2 + a );
sig2 = matmul2( G2i, sig2       );   h2 = matmul2( G2i, h2     );

%  pack to vector
vec = pack( obj, sig1, h1, sig2, h2 );
vec = vec( : );
