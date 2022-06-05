function [ e, phi ] = field( ltab, mtab, verts, a, diameter, epsr )
%  FIELD - Electric field and potential from Mie theory within quastistatic 
%    approximation.
%
%  Input
%    ltab       :  table of spherical harmonic degrees
%    mtab       :  table of spherical harmonic orders
%    verts      :  vertices where field is computed (must be sphere surface)
%    a          :  expansion coefficients
%    diameter   :  diameter of sphere
%    epsr       :  dielectric constant of sphere
%  Output
%    e          :  electric field
%    phi        :  scalar potential


%  static Mie coefficients 
c = ( 1 - epsr ) * ltab ./ ( ( 1 + epsr ) * ltab + 1 ) .*  ...
    ( diameter / 2 ) .^ ( 2 * ltab + 1 ) .* a;

%  number of vertices
nverts = size( verts, 1 );
%  convert points to spherical coordinates
[ phi, theta, r ] = cart2sph( verts( :, 1 ), verts( :, 2 ), verts( :, 3 ) );
%  unit vectors
unit = verts ./ repmat( r, 1, 3 );  
%  mean radius
r = mean( r );

%  spherical harmonics and vector spherical harmonics
[ x, y ] = vecspharm( ltab, mtab, pi / 2 - theta, phi );

%  scalar potential
phi = transpose( y ) * ( 4 * pi ./ ( 2 * ltab + 1 ) .* c ./ r .^ ( ltab + 1 ) );

%  prefactor
fac = 4 * pi ./ ( 2 * ltab + 1 ) .* c ./ r .^ ( ltab + 2 ); 
%  electric field
e = repmat( transpose( y ) * ( fac .* ( ltab + 1 ) ), [ 1, 3 ] ) .* unit +  ...
    cross( unit, reshape( sum(                                              ...
      repmat( 1i * sqrt( ltab .* ( ltab + 1 ) ) .* fac,                     ...
              [ 1, nverts, 3 ] ) .* x, 1 ), [ nverts, 3 ] ), 2 );
