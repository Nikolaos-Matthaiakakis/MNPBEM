function obj = initprecond( obj, enei )
%  Initialize preconditioner for H-matrices.
% 
%    See, e.g. Garcia de Abajo and Howie, PRB  65, 115418 (2002).

%  wavenumber
k = 2 * pi / enei;
%  dielectric functions
eps1 = spdiag( obj.eps1 );
eps2 = spdiag( obj.eps2 );
%  normal vector
nvec = obj.p.nvec;

%  Green functions and surface derivatives
G1 = compress( obj, obj.G1 );  H1 = compress( obj, obj.H1 );  
G2 = compress( obj, obj.G2 );  H2 = compress( obj, obj.H2 );  

%  use hierarchical or full matrices for preconditioner ?
switch obj.precond
  case 'hmat'
    inv2 = @( x ) lu( x );  mul2 = @( x, y ) rsolve( x, y );
  case 'full'
    %  expand matrices
    [ G1, H1 ] = deal( full( G1 ), full( H1 ) );
    [ G2, H2 ] = deal( full( G2 ), full( H2 ) );
    %  inversion and multiplication functions
    inv2 = @( x ) inv( x );  mul2 = @( x, y ) x * y;
end

%  inverse Green function
G1i = inv2( G1 );  obj = tocout( obj, 'G1i' );
G2i = inv2( G2 );  obj = tocout( obj, 'G2i' );
%  Sigma matrices [ Eq.(21) ]
Sigma1 = mul2( H1, G1i );  obj = tocout( obj, 'Sigma1' );
Sigma2 = mul2( H2, G2i );  obj = tocout( obj, 'Sigma2' );
%  inverse Delta matrix
Deltai = inv( Sigma1 - Sigma2 );  obj = tocout( obj, 'Deltai' );

deps = eps1 - eps2;
%  Sigma matrix
Sigma = eps1 * Sigma1 - eps2 * Sigma2 + k ^ 2 * deps * fun( Deltai, nvec ) * deps;

%  save variables 
sav.k = k;            %  wavenumber of light in vacuum
sav.nvec = nvec;      %  outer surface normals of discretized surface
sav.G1i = G1i;        %  inverse of  inside Green function G1
sav.G2i = G2i;        %  inverse of outside Green function G2
sav.eps1 = eps1;      %   inside dielectric function
sav.eps2 = eps2;      %  outside dielectric function
sav.Sigma1 = Sigma1;          %  H1 * G1i, Eq. (21)
sav.Deltai = Deltai;          %  inv( Sigma1 - Sigma2 ) 
sav.Sigmai = inv2( Sigma );   %  Eq. (21,22)

%  save structure
obj.sav = sav;
%  save statistics
if strcmp( obj.precond, 'hmat' )
  %  hierachical matrices and names
  hmat = { G1i, G2i, Sigma1, Sigma2, Deltai, sav.Sigmai };
  name = { 'G1i', 'G2i', 'Sigma1', 'Sigma2', 'Deltai', 'Sigmai' };
  %  loop over matrices
  for i = 1 : numel( hmat )
    obj = setstat( obj, name{ i }, hmat{ i } );
  end
end



function Deltai = fun( Deltai, nvec )
%  FUN - Decorate Deltai function with normal vectors, Eq. (21).

nvec1 = spdiag( nvec( :, 1 ) );
nvec2 = spdiag( nvec( :, 2 ) );
nvec3 = spdiag( nvec( :, 3 ) );

Deltai = nvec1 * Deltai * nvec1 + nvec2 * Deltai * nvec2 + nvec3 * Deltai * nvec3;        
