function dip = dipole( ltab, mtab, a, diameter, epsr )
%  DIPOLE - Dipole moment of sphere within quasistatic Mie theory.
%
%  Input
%    ltab       :  table of spherical harmonic degrees
%    mtab       :  table of spherical harmonic orders
%    a          :  expansion coefficients
%    diameter   :  diameter of sphere
%    epsr       :  dielectric constant of sphere
%  Output
%    dip        :  dipole moment

%  static Mie coefficients [ eq. (4.5) of Jackson ]
c = ( 1 - epsr ) * ltab ./ ( ( 1 + epsr ) * ltab + 1 ) .*  ...
    ( diameter / 2 ) .^ ( 2 * ltab + 1 ) .* a;

%  get the different contributions with LTAB == 1 and MTAB
qz =   sqrt( 4 * pi / 3 ) * c( intersect( find( ltab == 1 ), find( mtab ==   0 ) ) );
qp = - sqrt( 4 * pi / 3 ) * c( intersect( find( ltab == 1 ), find( mtab ==   1 ) ) );
qm =   sqrt( 4 * pi / 3 ) * c( intersect( find( ltab == 1 ), find( mtab == - 1 ) ) );

%  compute dipole moment
dip = qz * [ 0, 0, 1 ] + ( qp * [ 1, 1i, 0 ] + qm * [ 1, - 1i, 0 ] ) / sqrt( 2 );
