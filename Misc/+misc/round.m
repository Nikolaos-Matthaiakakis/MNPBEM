function x = round( x, n )
%  ROUND - Rounds each element of X to the left of the decimal point.
%
%  Usage :
%    x = round( x, n )
%  Input
%    x      :  argument
%    n      :  x is rounded to the left of the decimal point 
%  Output
%    x      :  rounded argument

x = builtin( 'round', x * 10 ^ n ) * 10 ^ ( - n );
