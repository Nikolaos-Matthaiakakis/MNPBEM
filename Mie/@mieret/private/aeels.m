function  [ ce, cm ] = aeels( ltab, mtab, beta )
%  AEELS - Spherical harmonics coefficients for EELS.
%    See F. J. Garcia de Abajo, Phys. Rev. B 59, 3095 (1999).
%
%  Input
%    ltab   :  table of spherical harmonic degrees
%    mtab   :  table of spherical harmonic orders
%    beta   :  ratio of velocity and speed of light
%
%  Output
%    ce      :  electric expansion coefficient [ eq. (31) ]
%    ce      :  magnetic expansion coefficient [ eq. (30) ]
%    a       :  coefficient (A9)


%  abscissa and weights for integration
persistent x w fac;

if isempty( x )
  %  Legendre-Gauss-Lobatto nodes and weights
  [ x, w ] = lglnodes( 100 );
end

%  table of factorials ( used for speedup )
if ( max( ltab + abs( mtab ) + 1 ) > length( fac ) )
  %  clear tabke of factorials
  fac = [];
  for i = 0 : max( ltab + abs( mtab ) ) + 1
    fac = [ fac, factorial( i ) ];
  end
end

%  coupling coefficients 
a = zeros( size( ltab ) );
%  gamma value
gamma = 1 / sqrt( 1 - beta ^ 2 );

%  loop over unique spherical harmonic degrees
for l = unique( ltab )'
  %  Legendre polynomial
  p = legendre( l, x );
  %  loop over spherical harmonics with m >= 0
  for m = 0 : l
    %  coefficient of Eq. (A9)
    aa = 0;
    %  alpha factor
    alpha = sqrt( ( 2 * l + 1 ) / ( 4 * pi ) *  ...
        fac( l - m + 1 ) / fac( l + m + 1 ) );
    for j = m : l
      %  restrict sum to even j + m integers
      if  mod( j + m, 2 ) == 0
        %  integral (A7)
        I = ( - 1 ) ^ m *                ...
            sum( w .* p( m + 1, : )' .*  ...
                ( 1 - x .^ 2 ) .^ ( j / 2 ) .* x .^ ( l - j ) );
        %  C factor (A9)
        C = 1i ^ ( l - j ) * alpha * fac2( 2 * l + 1 ) /  ...
            ( 2 ^ j * fac( l - j + 1 ) *                  ...
              fac( ( j - m ) / 2 + 1 ) * fac( ( j + m ) / 2 + 1 ) ) * I;
        %  add contribution
        aa = aa + C / ( beta ^ ( l + 1 ) * gamma ^ j );
      end
    end
    %  assign values to coefficients
    i1 = intersect( find( ltab == l ), find( mtab ==   m ) );
    i2 = intersect( find( ltab == l ), find( mtab == - m ) );
    a( i1 ) = aa;
    a( i2 ) = ( - 1 ) ^ m * aa;
  end
end

%  expansion coefficient of Eq. (15)
b = zeros( size( ltab ) );
%  we assume that ltab and mtab have been generated in sphtable
im = find( mtab ~= - ltab );
ip = find( mtab ~=   ltab );
b( ip ) = b( ip ) + a( ip + 1 ) .*  ...
    sqrt( ( ltab( ip ) + mtab( ip ) + 1 ) .* ( ltab( ip ) - mtab( ip ) ) );
b( im ) = b( im ) - a( im - 1 ) .*  ...
    sqrt( ( ltab( im ) - mtab( im ) + 1 ) .* ( ltab( im ) + mtab( im ) ) );    

%  magnetic and electric expansion coefficients of Eqs. (30,31)
cm = 1 ./ ( ltab .* ( ltab + 1 ) ) .* abs( 2 * beta .* mtab .* a ) .^ 2;
ce = 1 ./ ( ltab .* ( ltab + 1 ) ) .* abs( b / gamma ) .^ 2;


function [ x, w ] = lglnodes( n )
%  LGLNODES - Compute the Legendre-Gauss-Lobatto nodes.
%    adapted from Greg von Winkel

%  truncation + 1
n1 = n + 1;
%  use the Chebyshev-Gauss-Lobatto nodes as the first guess
x = cos( pi * ( 0 : n ) / n )';
%  Legendre Vandermonde Matrix
p = zeros( n1, n1 );

%  Compute P( n ) using the recursion relation.  Compute its first and
%  second derivatives and update x using the Newton-Raphson method.
xold = 2;

while max( abs( x - xold ) ) > eps
  xold = x;
  p( :, 1 ) = 1;    
  p( :, 2 ) = x;
  for k = 2 : n
    p( :, k + 1 ) =  ...
        ( ( 2 * k - 1 ) * x .* p( :, k ) - ( k - 1 ) * p( :, k - 1 ) ) / k;
  end   
  x = xold - ( x .* p( :, n1 ) - p( :, n ) ) ./ ( n1 * p( :, n1 ) );     
end

%  weights
w = 2 ./ ( n * n1 * p( :, n1 ) .^ 2 );


function  fun = fac2( n )
%  FAC2 -  compute  n!!
if mod( n, 2 ) == 0
  fun = prod( 2 : 2 : n );
else
  fun = prod( 1 : 2 : n );
end
