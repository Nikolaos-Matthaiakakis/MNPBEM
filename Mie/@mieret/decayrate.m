function [ tot, rad ] = decayrate( obj, enei, z )
%  Total and radiative decay rate for oscillating dipole.
%    Scattering rates are given in units of the free-space decay rate.
%    See Kim et al., Surf. Science 195, 1 (1988).
%
%  Usage for obj = mieret :
%    [ tot, rad ] = decayrate( obj, enei, pos )
%  Input
%    enei       :  wavelength of light in vacuum (only one value)
%    z          :  dipole positions on z axis
%  Output
%    tot        :      total scattering rate for dipole orientations x and z
%    rad        :  radiative scattering rate for dipole orientations x and z

assert( length( enei ) == 1 );

%  dielectric functions
[ epsb,  k   ] = obj.epsout( enei );
[ epsin, kin ] = obj.epsin(  enei );
%  total and radiative scattering rate
tot = zeros( length( z ), 2 );
rad = zeros( length( z ), 2 );

%  use only unique spherical harmonic degrees
l = unique( obj.ltab );
%  compute Riccati-Bessel functions for Mie coefficients
[ j1, h1, zjp1, zhp1 ] = riccatibessel( 0.5 * k   * obj.diameter, l );
[ j2,  ~, zjp2,    ~ ] = riccatibessel( 0.5 * kin * obj.diameter, l );
 
%  modified Mie coefficient [Eq. (11)]
A = ( j1 .* zjp2 - j2 .* zjp1 ) ./  ( j2 .* zhp1 - h1 .* zjp2 );
B = ( epsb  * j1 .* zjp2 - epsin * j2 .* zjp1 ) ./  ...
    ( epsin * j2 .* zhp1 - epsb  * h1 .* zjp2 );


%  loop over dipole positions and orientation
for iz = 1 : length( z )
   
  %  background wavenumber * dipole position
  y = k * z( iz );
  %  get spherical Bessel and Hankel functions at position of dipole
  [ j, h, zjp, zhp ] = riccatibessel( y, l );

  %  normalized nonradiative decay rates [Eq. (17,19)]
  tot( iz, 1 ) = 1 + 1.5 * real( sum( ( l + 0.5 ) .*  ...
    ( B .* ( zhp ./ y ) .^ 2  + A .* h .^ 2 ) ) );
  tot( iz, 2 ) = 1 + 1.5 * real( sum(  ...
    ( 2 * l + 1 ) .* l .* ( l + 1 ) .* B .* ( h / y ) .^ 2 ) );
  %  normalized radiative decay rates [Eq. (18,20)]
  rad( iz, 1 ) = 0.75 * sum( ( 2 * l + 1 ) .*  ...
    ( abs( j + A .* h ) .^ 2 + abs( ( zjp + B .* zhp ) ./ y ) .^ 2 ) );
  rad( iz, 2 ) = 1.5 * sum( ( 2 * l + 1 ) .* l .* ( l + 1 ) .*     ...
                                   abs( ( j + B .* h ) ./ y ) .^ 2 );                         
    
end
