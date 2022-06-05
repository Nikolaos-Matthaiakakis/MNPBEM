function [ sig, obj ] = mldivide( obj, exc )
%  Surface charges and currents for given excitation.
%    see Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015).
%
%  Usage for obj = bemretlayer :
%    [ sig, obj ] = obj \ exc
%  Input
%    exc    :  compstruct with fields for external excitation
%  Output
%    sig    :  compstruct with fields for surface charges and currents

%  initialize BEM solver (if needed)
obj = subsref( obj, substruct( '()', { exc.enei } ) );

%%  external perturbation and extract stored variables
%  Garcia de Abajo and Howie, PRB 65, 115418 (2002).

k      = obj.k;       %  wavenumber of light in vacuum
nvec   = obj.nvec;    %  outer surface normals of discretized surface
npar   = obj.npar;    %  parallel component of outer surface normal
eps1   = obj.eps1;    %  dielectric function inside of surface
eps2   = obj.eps2;    %  dielectric function outside of surface
G1i    = obj.G1i;     %  inverse of  inside Green function G1
G2pi   = obj.G2pi;    %  inverse of outside parallel Green function G2
G2     = obj.G2;      %  outside Green function G2
Sigma1 = obj.Sigma1;  %  H1 * G1i, Eq. (21)
Gamma  = obj.Gamma;   %  inv( Sigma1 - Sigma2 )
m      = obj.m;       %  response matrix for layer system

%  number of boundary elements
n = obj.p.n;
%  unit vector in z-direction
zunit = repmat( [ 0, 0, 1 ], n, 1 );

%  external excitation
[ phi, a, alpha, De ] = excitation( obj, exc );
%  decompose vector potential into parallel and perpendicular components
aperp = inner( zunit, a );
apar = a - outer( zunit, aperp );

%%  solve BEM equations
%  difference of dielectric functions
deps = eps1 - eps2;
%  modify alpha and De, Eq. (9,10)
alpha = alpha - matmul( Sigma1, a ) + 1i * k * outer( nvec, matmul( eps1, phi ) );
De = De - matmul( eps1, matmul( Sigma1, phi ) ) +  ...
    1i * k * inner( nvec, matmul( eps1, a   ) ) +  ...
    1i * k * inner( npar, matmul( deps * Gamma, alpha ) );
%  decompose into parallel and perpendicular components
alphaperp = inner( zunit, alpha );
alphapar = alpha - outer( zunit, alphaperp );
              
%  solve matrix equation, Eq. (10)
xi2 = cell2mat( m ) \ [ reshape( De, n, [] ); reshape( alphaperp, n, [] ) ];
%  decompose into surface charge and perpendicular surface current
sig2 = reshape( xi2( 1 : n, : ), size( De ) );
h2perp = reshape( xi2( n + 1 : end, : ), size( De ) );

%  parallel component of Green function, Eq. (8)
h2par = matmul( G2pi * Gamma, alphapar +  ...
   1i * k * outer( npar, matmul( deps * G2.ss, sig2 ) + matmul( deps * G2.sh, h2perp ) ) );
%  surface current
h2 = h2par + outer( zunit, h2perp );

%  surface charges at inner interface
sig1 = matmul( G1i, matmul( G2.ss, sig2 ) + matmul( G2.sh, h2perp ) + phi );
%  surface currents at inner interface
h1perp =  matmul( G1i, matmul( G2.hs, sig2 ) + matmul( G2.hh, h2perp ) + aperp );
h1par = matmul( G1i, matmul( G2.p, h2par ) + apar );
%  surface current
h1 = h1par + outer( zunit, h1perp );

%%  save everything in single structure
sig = compstruct( obj.p, exc.enei,  ...
                    'sig1', sig1, 'sig2', sig2, 'h1', h1, 'h2', h2 );
