function  [ x, y ] = vecspharm( ltab, mtab, theta, phi )
%  VECSPHARM - Vector spherical harmonics.
%
%  Usage :
%    [ x, y ] = vecspharm( ltab, mtab, theta, phi )
%  Input
%    ltab   :  table of spherical harmonic degrees
%    mtab   :  table of spherical harmonic orders
%    theta  :  polar angle
%    phi    :  azimuthal angle
%  Output
%    x      :  vector spherical harmonic [ Jackson eq. (9.119) ]
%    y      :  spherical harmonics

%  convert to column and row vectors
l = ltab( : );
m = mtab( : );

%  spherical harmonics
y  = spharm( l, m,     theta, phi );
yp = spharm( l, m + 1, theta, phi );
ym = spharm( l, m - 1, theta, phi );

%  dimension of theta and phi
dim = [ 1, length( phi( : ) ) ];
%  normalization constant
norm = 1 ./ sqrt( l .* ( l + 1 ) ); 
%  action of angular momentum operator on spherical harmonic
%    [ Jackson eq. (9.104) ]
lpy = repmat( norm .* sqrt( ( l - m ) .* ( l + m + 1 ) ), dim ) .* yp;
lmy = repmat( norm .* sqrt( ( l + m ) .* ( l - m + 1 ) ), dim ) .* ym;
lzy = repmat( norm .* m, dim ) .* y;

%  vector spherical harmonics
x = outer( lpy, [ 1, - 1i, 0 ] ) / 2 +  ...
    outer( lmy, [ 1,   1i, 0 ] ) / 2 +  ...
    outer( lzy, [ 0,    0, 1 ] );
  
function  c = outer( a, b )
%  OUTER - outer product of matrix a and vector b

c = cat( 3, cat( 3, b( 1 ) * a, b( 2 ) * a ), b( 3 ) * a );
