function obj = initprecond( obj, enei )
%  Initialize preconditioner for H-matrices.
% 
%    See Waxenegger et al., Comp. Phys. Commun. 193, 128 (2015).

%  wavenumber 
k = 2 * pi / enei;
%  dielectric functions
eps1 = spdiag( obj.eps1 );
eps2 = spdiag( obj.eps2 );
%  difference of dielectric function
ikdeps = 1i * k * ( eps1 - eps2 );
%  normal vector
nvec = obj.p.nvec;

%  compress Green functions and surface derivatives
[ G1, H1 ] = deal( compress( obj, obj.G1 ), compress( obj, obj.H1 ) );
%  loop over names 
for name = fieldnames( obj.G2 ) .'
  G2.( name{ 1 } ) = compress( obj, obj.G2.( name{ 1 } ) );
  H2.( name{ 1 } ) = compress( obj, obj.H2.( name{ 1 } ) );
end

%  inverse of G1 and of parallel component
G1i  = lu( G1   );  obj = tocout( obj, 'G1i'  );
G2pi = lu( G2.p );  obj = tocout( obj, 'G2pi' );
%  Sigma matrices [ Eq.(21) ]
Sigma1  = rsolve( H1,   G1i  );  obj = tocout( obj, 'Sigma1'  );
Sigma2p = rsolve( H2.p, G2pi );  obj = tocout( obj, 'Sigma2p' );
  
%  perpendicular component of normal vector
nperp = spdiag( nvec( :, 3 ) );   
%  Gamma matrix
Gamma = inv( Sigma1 - Sigma2p );  obj = tocout( obj, 'Gamma' );
Gammapar = ikdeps * fun( Gamma, nvec );

%  set up full matrix, Eq. (10)
m11 = ( eps1 * Sigma1 - Gammapar * ikdeps ) * G2.ss - eps2 * H2.ss - ( nperp * ikdeps ) * G2.hs;
m12 = ( eps1 * Sigma1 - Gammapar * ikdeps ) * G2.sh - eps2 * H2.sh - ( nperp * ikdeps ) * G2.hh;  
m21 = Sigma1 * G2.hs - H2.hs - nperp * ikdeps * G2.ss;
m22 = Sigma1 * G2.hh - H2.hh - nperp * ikdeps * G2.sh;
%  timing
obj = tocout( obj, 'm' );

%  L11 * U11 = M11
im11 = lu( m11 );     
%  L11 * U12 = M12
im12 = lsolve( m12, im11, 'L' );
%  L21 * U11 = M21
im21 = rsolve( m21, im11, 'U' );
%  L22 * U22 = M22 - L21 * U12
im22 = lu( m22 - im21 * im12 ); 
%  timing
obj = tocout( obj, 'im' );
  
%  save variables
sav.k = k;            %  wavenumber of light in vacuum
sav.nvec = nvec;      %  outer surface normals of discretized surface
sav.eps1 = eps1;      %   inside dielectric function
sav.eps2 = eps2;      %  outside dielectric function
sav.G1i    = G1i;     %  inverse of  inside Green function G1
sav.G2pi   = G2pi;    %  inverse of outside parallel Green function G2
sav.G2     = G2;      %  outside Green function G2
sav.Sigma1 = Sigma1;  %  H1 * G1i, Eq. (21)
sav.Gamma  = Gamma;   %  inv( Sigma1 - Sigma2 )
sav.im     = { im11, im12; im21, im22 };
                      %  response matrix for layer system                                            

%  save structure
obj.sav = sav;
%  save statistics
if strcmp( obj.precond, 'hmat' )
  %  hierachical matrices and names
  hmat = { G1i, G2pi, Sigma1, Sigma2p, Gamma, im11, im12, im21, im22 };
  name = { 'G1i', 'G2pi', 'Sigma1', 'Sigma2p', 'Gamma', 'im11', 'im12', 'im21', 'im22' };
  %  loop over matrices
  for i = 1 : numel( hmat )
    obj = setstat( obj, name{ i }, hmat{ i } );
  end
end
  

  
function Gamma = fun( Gamma, nvec )
%  FUN - Decorate Gamma function with normal vectors, Eq. (10a).

nvec1 = spdiag( nvec( :, 1 ) );
nvec2 = spdiag( nvec( :, 2 ) );

Gamma = nvec1 * Gamma * nvec1 + nvec2 * Gamma * nvec2;   
