function a = adipole( pos, dip, ltab, mtab )
%  ADIPOLE - Spherical harmonics coefficients for dipole in the
%    quasistatic limit. The dipole potential for a given degree l and
%     order m is of the form [ Jackson eq. (4.1) ]
%
%    Phi = 4 * pi / ( 2 * l + 1 ) * a( l, m ) * ...
%          spharm( l, m, theta, phi ) / r ^ ( l + 1 )
%
%  Input
%    pos    :  position of dipole
%    dip    :  vector dipole
%    ltab   :  table of spherical harmonic degrees
%    mtab   :  table of spherical harmonic orders
%  Output
%    a      :  expansion coefficients


%  convert position to spherical coordinates
[ phi, theta, r ] = cart2sph( pos( 1 ), pos( 2 ), pos( 3 ) );
%  unit vector to dipole position
e = pos( : ) / r;

%  convert dipole orientation to column vector
dip = dip( : );
%  convert table of spherical harmonic degrees to column vector
ltab = ltab( : );

%  spherical harmonics and vector spherical harmonics
[ x, y ] = vecspharm( ltab, mtab, pi / 2 - theta, phi );


%  expansion coefficients
a = - ( ( ltab + 1 ) * ( e' * dip ) .* conj( y ) +                                      ...
  1i * sqrt( ltab .* ( ltab + 1 ) ) .* ( squeeze( conj( x ) ) * cross( e, dip ) ) ) ./  ...
  r .^ ( ltab + 2 );
