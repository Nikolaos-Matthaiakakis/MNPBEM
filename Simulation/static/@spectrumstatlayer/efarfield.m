function [ field, k ] = efarfield( obj, dip, enei, dir )
%  EFARFIELD - Electric farfields for given dipole moment.
%    we use expressions of Novotny & Hecht, Nano Optics (2006), Sec. 10.6
%
%  Usage for obj = spectrumstatlayer :
%    [ field, k ] = efarfield( obj, dip, enei, dir )
%  Input
%    dip    :  dipole moment, must be located above substrate
%    enei   :  wavelength of light in vacuum
%    dir    :  light propagation direction 
%                (surface normals of unit sphere on default )
%  Output
%    field  :  scattered electric far-fields
%    k      :  wavenumber for propagation direction

%  default value for directions
if ~exist( 'dir', 'var' );  dir = obj.pinfty.nvec;  end

%  dipole moments
dip1 = dip( :, 1 ) .'; 
dip2 = dip( :, 2 ) .';
dip3 = dip( :, 3 ) .'; 

%  dielectric functions and wavenumbers
[ eps1, k1 ] = obj.layer.eps{ 1 }( enei );
[ eps2, k2 ] = obj.layer.eps{ 2 }( enei );
%  allocate array for electric field 
field = zeros( size( dir, 1 ), 3, size( dip1, 2 ) );
%  wavenumber in upper and lower medium
k( dir( :, 3 ) > 0 ) = k1;
k( dir( :, 3 ) < 0 ) = k2;

%%  propagation directions in upper medium
ind1 = dir( :, 3 ) >= 0 & ~any( abs( imag( dir ) ) > 1e-10, 2 );
%  multiplication function
mul = @( x, y ) bsxfun( @times, x, y );
  
if abs( imag( k1 ) ) < 1e-10
  %  express propagation directions in spherical coordinates
  [ phi, theta ] = cart2sph( dir( ind1, 1 ), dir( ind1, 2 ), dir( ind1, 3 ) );  
  %  correct for different Matlab definition of spherical coordinates
  theta = pi / 2 - theta;
  %  trigonometric functions
  sinp = sin( phi );  sint = sin( theta );
  cosp = cos( phi );  cost = cos( theta );

  %  z-components of wavevectors
  k1z = k1 * dir( ind1, 3 );
  k2z = sqrt( k2 ^ 2 - k1 ^ 2 + k1z .^ 2 );
  %  Fresnel reflection coefficients, Eq. (2.49)
  rte = ( k1z - k2z ) ./ ( k1z + k2z );
  rtm = ( eps2 * k1z - eps1 * k2z ) ./ ( eps2 * k1z + eps1 * k2z );
  %  coefficients in quasistatic limit, Eq. (10.33 - 35), (s,p) = (TE,TM)
  [ phi1, phi2, phi3 ] = deal( 1 + rtm, 1 - rtm, 1 + rte );

  %  electric field components
  etheta = mul( cosp * dip1 + sinp * dip2, cost .* phi2 ) - ( sint .* phi1 ) * dip3;
  ephi = - mul( sinp * dip1 - cosp * dip2, phi3 );
  %  electric field
  field( ind1, 1, : ) =   mul( etheta, cost .* cosp ) - mul( ephi, sinp );
  field( ind1, 2, : ) =   mul( etheta, cost .* sinp ) + mul( ephi, cosp );
  field( ind1, 3, : ) = - mul( etheta, sint );
else
  field( ind1, :, : ) = 0;
end

%%  propagation directions in lower medium
ind2 = dir( :, 3 ) < 0 & ~any( abs( imag( dir ) ) > 1e-10, 2 );  

if abs( imag( k2 ) ) < 1e-10
  %  express propagation directions in spherical coordinates
  [ phi, theta ] = cart2sph( dir( ind2, 1 ), dir( ind2, 2 ), dir( ind2, 3 ) );  
  %  correct for different Matlab definition of spherical coordinates
  theta = pi / 2 - theta;
  %  trigonometric functions
  sinp = sin( phi );  sint = sin( theta );
  cosp = cos( phi );  cost = cos( theta );

  %  z-components of wavevectors
  k2z = - k2 * dir( ind2, 3 );
  k1z = sqrt( k1 ^ 2 - k2 ^ 2 + k2z .^ 2 ) + 1e-10i;  k1z = k1z .* sign( imag( k1z ) );
  %  Novotny & Hecht, Eq. (10.31)
  stilde = k1z ./ k2;
  %  Fresnel transmission coefficients, Eq. (2.50)
  tte = 2 * k1z ./ ( k1z + k2z );
  ttm = 2 * eps2 * k1z ./ ( eps2 * k1z + eps1 * k2z ) * sqrt( eps1 / eps2 );
  %  coefficients in quasistatic limit, Eq. (10.36 - 38), (s,p) = (TE,TM)
  phi1 =   sqrt( eps2 / eps1 ) * cost ./ stilde .* ttm;
  phi2 = - sqrt( eps2 / eps1 )                  .* ttm;
  phi3 =                         cost ./ stilde .* tte;

  %  comparison with the retarded simulations indicates that there is a sign
  %  error in the equations, this can be also seen by plotting the fields on
  %  a unit sphere for substrates where the dielectric functions are almost
  %  equal
  [ phi1, phi2, phi3 ] = deal( - phi1, - phi2, - phi3 );

  %  electric field components
  etheta = mul( cosp * dip1 + sinp * dip2, cost .* phi2 ) - ( sint .* phi1 ) * dip3;
  ephi = - mul( sinp * dip1 - cosp * dip2, phi3 );
  %  electric field
  field( ind2, 1, : ) =   mul( etheta, cost .* cosp ) - mul( ephi, sinp );
  field( ind2, 2, : ) =   mul( etheta, cost .* sinp ) + mul( ephi, cosp );
  field( ind2, 3, : ) = - mul( etheta, sint );
else
  field( ind2, :, : ) = 0;
end

%  prefactor for electric field, Eq. (10.32)
%    we neglect the factor 1/eps1 which gives wrong cross sections in
%    comparison with Mie theory
field = k1 ^ 2 * field;
