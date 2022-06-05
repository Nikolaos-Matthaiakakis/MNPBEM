function [ x, w ] = lglnodes( n )
%  LGLNODES -  Legendre-Gauss-Lobatto nodes for integration.
%    Adapted from Greg von Winckel.
%
%  Usage :
%    [ x, w ] = lglnodes( n )
%  Input
%    n  	:  number of integration points
%  Output
%    x      :  integration points in interval [ - 1, 1 ]
%    w      :  integration weights

%  truncation + 1
n1 = n + 1;
%  use the Chebyshev-Gauss-Lobatto nodes as the first guess
x = cos( pi * ( 0 : n ) / n )';
%  Legendre Vandermonde Matrix
p = zeros( n1, n1 );
%  Compute P_(N) using the recursion relation.
%  Compute its first and second derivatives and 
%  update x using the Newton-Raphson method.
xold = 2 ;
while max( abs( x - xold ) ) > eps
  xold = x;
  p( :, 1 ) = 1;    
  p( :, 2 ) = x;
  for k = 2 : n
    p( :, k + 1 )= ( ( 2 * k - 1 ) * x .* p( :, k ) -( k - 1 ) * p( :, k - 1 ) ) / k;
  end
  x = xold - ( x .* p( :, n1 ) - p( :, n ) ) ./ ( n1 * p( :, n1 ) );
end
w = 2 ./ ( n* n1 * p( :, n1 ) .^ 2 );
