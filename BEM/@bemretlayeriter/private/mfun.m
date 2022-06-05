function vec = mfun( obj, vec )
%  MFUN - Preconditioner for CGS, BICGSTAB, GMRES.
%
%  See Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015).

%%  external perturbation and extract stored variables
%  unpack matrices
[ phi, a, De, alpha ] = unpack( obj, vec );
%  get variables for evaluation of preconditioner
sav = obj.sav;

k = sav.k;            %  wavenumber of light in vacuum
nvec = sav.nvec;      %  outer surface normals of discretized surface
G2   = sav.G2;        %  Green function
G1i  = sav.G1i;       %  inverse of  inside Green function G1
G2pi = sav.G2pi;      %  inverse of outside Green function G2 (parallel)
eps1 = sav.eps1;      %   inner dielectric function
eps2 = sav.eps2;      %  outer dielectric function
Sigma1 = sav.Sigma1;          %  H1 * G1i
Gamma  = sav.Gamma;           %  inv( Sigma1 - Sigma2p ) 
im     = sav.im;              %  Eqs. (10a,b)

deps = eps1 - eps2;
%  parallel and perpendicular components of NVEC and A
npar = nvec( :, 1 : 2 );
[ apar, aperp ] = deal( a( :, 1 : 2, : ), squeeze( a( :, 3, : ) ) );

%%  solve BEM equations
%  modify MATMUL (inv and LU matrices)
matmul1 = @( a, b ) reshape( a * reshape( b, size( b, 1 ), [] ), size( b ) );
matmul2 = @( a, b ) reshape( solve( a, reshape( b, size( b, 1 ), [] ) ), size( b ) );

%  modify alpha 
alpha = alpha - matmul1( Sigma1, a ) + 1i * k * outer( nvec, eps1 * phi );
%  parallel and perpendicular component
[ alphapar, alphaperp ] = deal( alpha( :, 1 : 2, : ), squeeze( alpha( :, 3, : ) ) );
%  modify De
De = De - eps1 * Sigma1 * phi + 1i * k * inner( nvec, matmul1( eps1, a ) ) +  ...
                 1i * k * inner( npar, matmul1( deps * Gamma, alphapar ) );
        
%  solve Eq. (10)
[ sig2, h2perp ] = fun( im, De, alphaperp );
%  parallel component of Green function, Eq. (A.1)
h2par = matmul2( G2pi, matmul1( Gamma, alphapar +  ...
    1i * k * outer( npar, deps * ( G2.ss * sig2 + G2.sh * h2perp ) ) ) );
%  surface charges at inner interface
sig1 = matmul2( G1i, G2.ss * sig2 + G2.sh * h2perp + phi );
%  surface currents at inner interface
h1perp = matmul2( G1i, G2.hh * h2perp + G2.hs * sig2 + aperp );
h1par = matmul2( G1i, matmul1( G2.p, h2par ) + apar );  
 
%  pack to single vector
vec = pack( obj, sig1, h1par, h1perp, sig2, h2par, h2perp );
vec = vec( : );


function [ x1, x2 ] = fun( M, b1, b2 )
%  FUN - Solve system of linear equations using LU decomposition.

[ L, U ] = deal( M );
%  [ L11, 0; L21, L22 ] * [ y1; y2 ] = [ b1; b2 ]
y1 = solve( L{ 1, 1 }, b1, 'L' );
y2 = solve( L{ 2, 2 }, b2 - L{ 2, 1 } * y1, 'L' );
%  [ U11, U12; 0, U22 ] * [ x1; x2 ] = [ y1; y2 ]
x2 = solve( U{ 2, 2 }, y2, 'U' );
x1 = solve( U{ 1, 1 }, y1 - U{ 1, 2 } * x2, 'U' );


