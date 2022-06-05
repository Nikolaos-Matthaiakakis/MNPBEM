function [ j, h, zjp, zhp ] = riccatibessel( z, ltab )
%  RICCATIBESSEL - Riccati-Bessel functions.
%    Abramowitz and Stegun, Handbook of Mathematical Functions, Chap. 10.
%
%  INPUT
%    z      :  argument
%    ltab   :  angular momentum components
%
%  OUTPUT
%    j      :  spherical Bessel function of order 1
%    h      :  spherical Bessel function of order 2
%    zjp    :  [ z j( z ) ]'
%    zhp    :  [ z h( z ) ]'


%  unique angular component vector
l = 1 : max( ltab );

%  spherical Bessel functions of first and second kind  
%  (10.1.1) , (10.1.11) , (10.1.12)
j0 =   sin( z ) / z;  j = sqrt( pi / ( 2 * z ) ) * besselj( l( : ) + 0.5, z );
y0 = - cos( z ) / z;  y = sqrt( pi / ( 2 * z ) ) * bessely( l( : ) + 0.5, z );

%  spherical Bessel function of third kind (10.1.1)
h0 = j0 + 1i * y0;  h = j + 1i * y;

%  derivatives (10.1.23), (10.1.24)
zjp = z * [ j0;  j( 1 : length( l ) - 1 ) ] - l( : ) .* j;
zhp = z * [ h0;  h( 1 : length( l ) - 1 ) ] - l( : ) .* h;


%  table assignement
j = j( ltab );   zjp = zjp( ltab );
h = h( ltab );   zhp = zhp( ltab );
