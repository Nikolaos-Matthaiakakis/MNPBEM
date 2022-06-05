function [ sig, obj ] = mldivide( obj, exc )
%  Surface charges and currents for given excitation.
%
%  Usage for obj = bemret :
%    [ sig, obj ] = obj \ exc
%  Input
%    exc    :  compstruct with fields for external excitation
%  Output
%    sig    :  compstruct with fields for surface charges and currents

%  initialize BEM solver (if needed)
obj = subsref( obj, substruct( '()', { exc.enei } ) );

%%  external perturbation and extract stored variables
%  Garcia de Abajo and Howie, PRB 65, 115418 (2002).

[ phi, a, alpha, De ] = excitation( obj, exc ); 

k = obj.k;              %  wavenumber of light in vacuum
nvec = obj.nvec;        %  normal vectors of discretized surface
G1i  = obj.G1i;         %  inverse of  inside Green function G1
G2i  = obj.G2i;         %  inverse of outside Green function G2
L1   = obj.L1;          %  G1 * eps1 * G1i, Eq. (22)
L2   = obj.L2;          %  G2 * eps2 * G2i
Sigma1 = obj.Sigma1;    %  H1 * G1i, Eq. (21)
Deltai = obj.Deltai;    %  inv( Sigma1 - Sigma2 ) 
Sigmai = obj.Sigmai;    %  Eq. (21,22)

%%  solve BEM equations
%  modify alpha and De
alpha = alpha - matmul( Sigma1, a ) +  ...
                1i * k * outer( nvec, matmul( L1, phi ) );
De = De - matmul( Sigma1, matmul( L1, phi ) ) +  ...
                1i * k * inner( nvec, matmul( L1, a ) );
              
%  Eq. (19)
sig2 = matmul( Sigmai,  ...
    De + 1i * k * inner( nvec, matmul( L1 - L2, matmul( Deltai, alpha ) ) ) );
%  Eq. (20)
h2 = matmul( Deltai,  ...
    1i * k * outer( nvec, matmul( L1 - L2, sig2 ) ) + alpha );

%%  surface charges and currents
sig1 = matmul( G1i, sig2 + phi );   h1 = matmul( G1i, h2 + a );
sig2 = matmul( G2i, sig2       );   h2 = matmul( G2i, h2     );

%%  save everything in single structure
sig = compstruct( obj.p, exc.enei,  ...
                    'sig1', sig1, 'sig2', sig2, 'h1', h1, 'h2', h2 );
