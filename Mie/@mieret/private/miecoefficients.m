function [ a, b, c, d ] = miecoefficients( k, diameter, epsr, mur, l )
%  MIECOEFFICIENTS - Mie coefficients according to Bohren and Huffman (1983).
%
%  Input
%    k          :  wavevector of light outside of sphere
%    diameter   :  diameter of sphere
%    epsr       :  dielectric constant of sphere
%    mur        :  magnetic permeability of sphere
%    l          :  angular momentum components
%  Output
%    Mie coefficients a, b, c, d


%  refractive index
nr = sqrt( epsr * mur );

%  compute Riccati-Bessel functions
[ j1,  ~, zjp1,    ~ ] = riccatibessel( nr * k * diameter / 2, l );
[ j2, h2, zjp2, zhp2 ] = riccatibessel(      k * diameter / 2, l );

%  Mie coefficients for outside field
a = ( nr ^ 2 * j1 .* zjp2 - mur * j2 .* zjp1 ) ./  ...
    ( nr ^ 2 * j1 .* zhp2 - mur * h2 .* zjp1 );
b = ( mur * j1 .* zjp2 - j2 .* zjp1 ) ./  ...
    ( mur * j1 .* zhp2 - h2 .* zjp1 );

%  Mie coefficients for inside field
c = ( mur * j2 .* zhp2 - mur * h2 .* zjp2 ) ./  ...
    ( mur * j1 .* zhp2 -       h2 .* zjp1 );
d = ( mur * nr *     j2 .* zhp2 - mur * nr * h2 .* zjp2 ) ./  ...
    (       nr ^ 2 * j1 .* zhp2 - mur *      h2 .* zjp1 );
