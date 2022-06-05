function [ sig, obj ] = mldivide( obj, exc )
%  Surface charges and currents for given excitation.
%
%  Usage for obj = bemretmirror :
%    [ sig, obj ] = obj \ exc
%  Input
%    exc    :  COMPSTRUCTMIRROR with fields for external excitation
%  Output
%    sig    :  COMPSTRUCTMIRROR with fields for surface charges and currents

%  initialize BEM solver (if needed)
obj = subsref( obj, substruct( '()', { exc.enei } ) );
%  extract stored variables
%    notion according to Garcia de Abajo and Howie, PRB 65, 115418 (2002).

k    = obj.k;           %  wavenumber of light in vacuum
nvec = obj.nvec;        %  normal vectors of discretized surface
G1i  = obj.G1i;         %  inverse of  inside Green function G1
G2i  = obj.G2i;         %  inverse of outside Green function G2
L1   = obj.L1;          %  G1 * eps1 * G1i, Eq. (22)
L2   = obj.L2;          %  G2 * eps2 * G2i
Sigma1 = obj.Sigma1;    %  H1 * G1i, Eq. (21)
Deltai = obj.Deltai;    %  inv( Sigma1 - Sigma2 ) 

[ nx, ny, nz ] = deal( nvec( :, 1 ), nvec( :, 2 ), nvec( :, 3 ) );
%  allocate COMPSTRUCTMIRROR object for surface charges
sig = compstructmirror( obj.p, exc.enei, exc.fun );

%  loop over excitations
for i = 1 : length( exc.val )

  %  extrenal excitation   
  [ phi, a, alpha, De ] = excitation( obj, exc.val{ i } );
  %  symmetry values for excitation
  x = obj.p.symindex( exc.val{ i }.symval( 1, : ) );
  y = obj.p.symindex( exc.val{ i }.symval( 2, : ) );
  z = obj.p.symindex( exc.val{ i }.symval( 3, : ) );
  
  %  Sigmai matrix
  [ Sigmai, obj ] = initsigmai( obj, x, y, z );

  %  modify alpha and De
  alphax = index( alpha, 1 ) - matmul( Sigma1{ x }, index( a, 1 ) ) + ...
                      1i * k * matmul( nx, matmul( L1{ z }, phi ) );
  alphay = index( alpha, 2 ) - matmul( Sigma1{ y }, index( a, 2 ) ) + ...
                      1i * k * matmul( ny, matmul( L1{ z }, phi ) );
  alphaz = index( alpha, 3 ) - matmul( Sigma1{ z }, index( a, 3 ) ) + ...
                      1i * k * matmul( nz, matmul( L1{ z }, phi ) );
  De = De - matmul( Sigma1{ z }, matmul( L1{ z }, phi ) ) +  ...
            1i * k * matmul( nx, matmul( L1{ x }, index( a, 1 ) ) ) +  ...
            1i * k * matmul( ny, matmul( L1{ y }, index( a, 2 ) ) ) +  ...
            1i * k * matmul( nz, matmul( L1{ z }, index( a, 3 ) ) );

  %  Eq. (19)
  sig2 = matmul( Sigmai, De + 1i * k * (  ...
      matmul( nx, matmul( L1{ x } - L2{ x }, matmul( Deltai{ x }, alphax ) ) ) +  ...
      matmul( ny, matmul( L1{ y } - L2{ y }, matmul( Deltai{ y }, alphay ) ) ) +  ...
      matmul( nz, matmul( L1{ z } - L2{ z }, matmul( Deltai{ z }, alphaz ) ) ) ) );

  %  Eq. (20)
  h2x = matmul( Deltai{ x },  ...
      1i * k * matmul( nx, matmul( L1{ z } - L2{ z }, sig2 ) ) + alphax );
  h2y = matmul( Deltai{ y },  ...
      1i * k * matmul( ny, matmul( L1{ z } - L2{ z }, sig2 ) ) + alphay );
  h2z = matmul( Deltai{ z },  ...
      1i * k * matmul( nz, matmul( L1{ z } - L2{ z }, sig2 ) ) + alphaz );
  

  %  surface charges and currents
  sig.val{ i }.sig1 = matmul( G1i{ z }, sig2 + phi );   
  sig.val{ i }.sig2 = matmul( G2i{ z }, sig2       );  
  %  save symmetry values
  sig.val{ i }.symval = exc.val{ i }.symval;

  sig.val{ i }.h1 = vector( matmul( G1i{ x }, h2x + index( a, 1 ) ),  ...
                            matmul( G1i{ y }, h2y + index( a, 2 ) ),  ...
                            matmul( G1i{ z }, h2z + index( a, 3 ) ) );
  sig.val{ i }.h2 = vector( matmul( G2i{ x }, h2x ),  ...
                            matmul( G2i{ y }, h2y ),  ...
                            matmul( G2i{ z }, h2z ) );
           
end
           

function vi = index( v, ind )
%  INDEX - Extract component from vector.

siz = size( v );
if length( siz ) == 2
  vi = v( :, ind );
else
  v  = reshape( v, siz( 1 ), 3, [] );
  siz = [ siz( 1 ), siz( 3 : end ) ];
  vi = reshape( v( :, ind, : ), siz );
end

function v = vector( vx, vy, vz )
%  VECTOR - Combine components to vector.

siz = size( vx );
siz = [ siz( 1 ), 1, siz( 2 : end ) ];

v = cat( 2,  ...
    reshape( vx, siz ), reshape( vy, siz ), reshape( vz, siz ) );
