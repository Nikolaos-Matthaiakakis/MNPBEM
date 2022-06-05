function [ par, perp ] = bemsolve( obj, enei, kpar )
%  BEMSOLVE - Solve BEM equation for layer structure.
%    see Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015).
%
%  Usage for obj = layerstructure :
%    [ par, perp ] = bemsolve( obj, enei, kpar )
%  Input
%    enei     :  wavelength of light in vacuum
%    kpar     :  parallel component of wavevector
%  Output
%    par      :  matrix for parallel surface current
%    perp     :  matrix for perpendicular surface current or surface charge

%  wavenumber of light in vacuum
k0 = 2 * pi / enei;
%  dielectric function and wavenumber
[ eps, k ] = cellfun( @( eps ) ( eps( enei ) ), obj.eps );
%  perpendicular component of wavevector
kz = sqrt( k .^ 2 - kpar ^ 2 );
kz = kz .* sign( imag( kz + 1e-10i ) );

%  number of interfaces
n = numel( obj.z );
%  intralayer Green function
G0 = 2i * pi ./ kz;
%  interlayer Green function
if n > 1
  G = 2i * pi ./ kz( 2 : end - 1 ) .*  ...
       exp( 1i * kz( 2 : end - 1 ) .* abs( diff( obj.z ) ) );
else
  G = [];
end

%%  parallel surface current
%  size of matrices
siz = [ 2 * n, 2 * n ];
%  matrices for solution of BEM equations
lhs = zeros( siz );
rhs = zeros( siz );
%  indices for [ h2( mu ), h1( mu + 1 ), ... ]
i1 = 2 : 2 : 2 * n;  
i2 = 1 : 2 : 2 * n;  
%  indices for equations
ind1 = 1 : 2 : 2 * n;
ind2 = 2 : 2 : 2 * n;

%%  continuity of vector potential [Eq. (13a)]
%  + G0( mu + 1 ) * h1( mu + 1 )
lhs( sub2ind( siz, ind1, i1 ) ) =   G0( 2 : end );
%  - G0( mu ) * h2( mu )
lhs( sub2ind( siz, ind1, i2 ) ) = - G0( 1 : end - 1 ); 
%  - G( mu ) * h1( mu )
lhs( sub2ind( siz, ind1( 2 : end ), i1( 1 : end - 1 ) ) ) = - G;
%  G( mu + 1 ) * h2( mu + 1 )
lhs( sub2ind( siz, ind1( 1 : end - 1 ), i2( 2 : end ) ) ) =   G;

%  - a1( mu + 1 )
rhs( sub2ind( siz, ind1, i1 ) ) = - 1;
%  + a2( mu )
rhs( sub2ind( siz, ind1, i2 ) ) =   1;

%%  continuity of derivative of vector potential [Eq. (13b)]
%  2 * pi * i * h1( mu + 1 )
lhs( sub2ind( siz, ind2, i1 ) ) = 2i * pi;
%  2 * pi * i * h2( m )
lhs( sub2ind( siz, ind2, i2 ) ) = 2i * pi;
if n > 1
  %  - kz( mu ) * G( mu ) * h1( mu )
  lhs( sub2ind( siz, ind2( 2 : end ), i1( 1 : end - 1 ) ) ) = - kz( 2 : end - 1 ) .* G;
  %  - kz( mu + 1 ) * G( mu + 1 ) * h2( mu + 1 )
  lhs( sub2ind( siz, ind2( 1 : end - 1 ), i2( 2 : end ) ) ) = - kz( 2 : end - 1 ) .* G;
end

%  kz( mu + 1 ) * a1( mu + 1 )
rhs( sub2ind( siz, ind2, i1 ) ) = kz( 2 : end );
%  kz( mu ) * a2( mu )
rhs( sub2ind( siz, ind2, i2 ) ) = kz( 1 : end - 1 );

%%  matrix for solution of BEM equation (parallel)
par = lhs \ rhs;


%%  perpendicular surface current and surface charge
%  size of matrices
siz = [ 4 * n, 4 * n ];
%  matrices for solution of BEM equations
lhs = zeros( siz );
rhs = zeros( siz );
%  indices for surface current (i2,j2) and surface charge (i1,j1)
i1 = 3 : 4 : 4 * n;  i2 = 1 : 4 : 4 * n;
j1 = 4 : 4 : 4 * n;  j2 = 2 : 4 : 4 * n;
% indices for equations
ind1 = 1 : 4 : 4 * n;  ind2 = 2 : 4 : 4 * n;
ind3 = 3 : 4 : 4 * n;  ind4 = 4 : 4 : 4 * n;

%%  continuity of scalar potential [Eq. (14a)]
%  + G0( mu + 1 ) * sig1( mu + 1 )
lhs( sub2ind( siz, ind1, i1 ) ) =   G0( 2 : end );
%  - G0( mu ) * sig2( mu )
lhs( sub2ind( siz, ind1, i2 ) ) = - G0( 1 : end - 1 ); 
%  - G( mu ) * sig1( mu )
lhs( sub2ind( siz, ind1( 2 : end ), i1( 1 : end - 1 ) ) ) = - G;
%  G( mu + 1 ) * sig2( mu + 1 )
lhs( sub2ind( siz, ind1( 1 : end - 1 ), i2( 2 : end ) ) ) =   G;

%  - phi1( mu + 1 )
rhs( sub2ind( siz, ind1, i1 ) ) = - 1;
%  + phi2( mu )
rhs( sub2ind( siz, ind1, i2 ) ) =   1;

%%  continuity of vector potential [Eq. (14b)]
%  + G0( mu + 1 ) * h1( mu + 1 )
lhs( sub2ind( siz, ind2, j1 ) ) =   G0( 2 : end );
%  - G0( mu ) * h2( mu )
lhs( sub2ind( siz, ind2, j2 ) ) = - G0( 1 : end - 1 ); 
%  - G( mu ) * h1( mu )
lhs( sub2ind( siz, ind2( 2 : end ), j1( 1 : end - 1 ) ) ) = - G;
%  G( mu + 1 ) * h2( mu + 1 )
lhs( sub2ind( siz, ind2( 1 : end - 1 ), j2( 2 : end ) ) ) =   G;

%  - a1( mu + 1 )
rhs( sub2ind( siz, ind2, j1 ) ) = - 1;
%  + a2( mu )
rhs( sub2ind( siz, ind2, j2 ) ) =   1;

%%  continuity of dielectric displacement [Eq. (14c)]
%  2 * pi * i * eps( mu + 1 ) * sig1( mu + 1 )
lhs( sub2ind( siz, ind3, i1 ) ) = 2i * pi * eps( 2 : end );
%  2 * pi * i * eps( mu ) * sig2( mu )
lhs( sub2ind( siz, ind3, i2 ) ) = 2i * pi * eps( 1 : end - 1 );
%  + k0 * G0( mu + 1 ) * eps( mu + 1 ) * h1( mu + 1 )
lhs( sub2ind( siz, ind3, j1 ) ) =   k0 * G0( 2 : end     ) .* eps( 2 : end     );
%  - k0 * G0( mu ) * eps( mu ) * h2( mu )
lhs( sub2ind( siz, ind3, j2 ) ) = - k0 * G0( 1 : end - 1 ) .* eps( 1 : end - 1 );
if n > 1
  %  - kz( mu ) * eps( mu ) * G( mu ) * sig1( mu )
  lhs( sub2ind( siz, ind3( 2 : end ), i1( 1 : end - 1 ) ) ) =  ...
                                    - kz( 2 : end - 1 ) .* eps( 2 : end - 1 ) .* G;
  %  - kz( mu + 1 ) * eps( mu + 1 ) * G( mu + 1 ) * sig2( mu + 1 )          
  lhs( sub2ind( siz, ind3( 1 : end - 1 ), i2( 2 : end ) ) ) =  ...
                                    - kz( 2 : end - 1 ) .* eps( 2 : end - 1 ) .* G;
  %  - k0 * eps( mu ) * G( mu ) * h1( mu )
  lhs( sub2ind( siz, ind3( 2 : end ), j1( 1 : end - 1 ) ) ) =  ...
                                                    - k0 * eps( 2 : end - 1 ) .* G;
  %  + k0 * eps( mu + 1 ) * G( mu + 1 ) * h2( mu + 1 )
  lhs( sub2ind( siz, ind3( 1 : end - 1 ), j2( 2 : end ) ) ) =  ...
                                                      k0 * eps( 2 : end - 1 ) .* G;
end
                            
%  + kz( mu + 1 ) * eps( mu + 1 ) * phi1( mu + 1 )          
rhs( sub2ind( siz, ind3, i1 ) ) = kz( 2 : end     ) .* eps( 2 : end     );                            
%  + kz( mu ) * eps( mu ) * phi2( mu )
rhs( sub2ind( siz, ind3, i2 ) ) = kz( 1 : end - 1 ) .* eps( 1 : end - 1 );
%  - k0 * eps( mu + 1 ) * a1( mu + 1 )
rhs( sub2ind( siz, ind3, j1 ) ) = - k0 * eps( 2 : end     );                            
%  + k0 * eps( mu ) * a2( mu )
rhs( sub2ind( siz, ind3, j2 ) ) =   k0 * eps( 1 : end - 1 );
 
%%  continuity of derivative of vector potential [Eq. (14d)]
%  2 * pi * i * h1( mu + 1 )
lhs( sub2ind( siz, ind4, j1 ) ) = 2i * pi;
%  2 * pi * i * h2( mu )
lhs( sub2ind( siz, ind4, j2 ) ) = 2i * pi;
%  + k0 * G0( mu + 1 ) * eps( mu + 1 ) * sig1( mu + 1 )
lhs( sub2ind( siz, ind4, i1 ) ) =   k0 * G0( 2 : end     ) .* eps( 2 : end     );
%  - k0 * G0( mu ) * eps( mu ) * sig2( mu )
lhs( sub2ind( siz, ind4, i2 ) ) = - k0 * G0( 1 : end - 1 ) .* eps( 1 : end - 1 );
if n > 1
  %  - kz( mu ) * G( mu ) * h1( mu )
  lhs( sub2ind( siz, ind4( 2 : end ), j1( 1 : end - 1 ) ) ) = - kz( 2 : end - 1 ) .* G;
  %  - kz( mu + 1 ) * G( mu + 1 ) * h2( mu + 1 )          
  lhs( sub2ind( siz, ind4( 1 : end - 1 ), j2( 2 : end ) ) ) = - kz( 2 : end - 1 ) .* G;
  %  - k0 * eps( mu ) * G( mu ) * sig1( mu )
  lhs( sub2ind( siz, ind4( 2 : end ), i1( 1 : end - 1 ) ) ) =  ...
                                                        - k0 * eps( 2 : end - 1 ) .* G;
  %  + k0 * eps( mu + 1 ) * G( mu + 1 ) * sig2( mu + 1 )
  lhs( sub2ind( siz, ind4( 1 : end - 1 ), i2( 2 : end ) ) ) =  ...
                                                          k0 * eps( 2 : end - 1 ) .* G;
end
                            
%  + kz( mu + 1 ) * a1( mu + 1 )          
rhs( sub2ind( siz, ind4, j1 ) ) = kz( 2 : end     );
%  + kz( mu ) * a2( mu )
rhs( sub2ind( siz, ind4, j2 ) ) = kz( 1 : end - 1 );
%  - k0 * eps( mu + 1 ) * phi1( mu + 1 )
rhs( sub2ind( siz, ind4, i1 ) ) =  - k0 * eps( 2 : end     );
%  + k0 * eps( mu ) * phi2( mu )
rhs( sub2ind( siz, ind4, i2 ) ) =  + k0 * eps( 1 : end - 1 );
   
%%  matrix for solution of BEM equation (perpendicular)
perp = lhs \ rhs;
