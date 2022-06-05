function [ prob, prad ] = loss( obj, b, enei, beta )
%  LOSS - Energy loss probability for fast electron in vicinity of dielectric sphere.
%    see, F. J. Garcia de Abajo, Phys. Rev. B 59, 3095 (1999).
%
%  Usage for obj = mieret :
%    [ prob, prad ] = loss( obj, b, enei, beta )
%  Input
%    b      :  impact parameter
%    enei   :  wavelength of light in vacuum
%    beta   :  electron velocity in units of speed of light (default 0.7)
%  Output
%    prob   :  EELS probability, see Eq. (29)
%    prad   :  photon emission probability, Eq. (37)

%  make sure that electron trajectory does not penetrate sphere
assert( all( b > 0 ) );
%  add sphere radius to impact parameter
b = 0.5 * obj.diameter + b;

%  electron velocity in units of speed of light
if ~exist( 'beta', 'var' );  beta = 0.7;  end
%  gamma factor
gamma = 1 ./ sqrt( 1 - beta ^ 2 );

% EELS and photon loss probability
[ prob, prad ] = deal( zeros( length( b ), length( enei ) ) );
%  spherical harmonics
[ ltab, mtab ] = sphtable( max( obj.ltab( : ) ), 'full' );
%  spherical harmonics coefficients for EELS
[ ce, cm ] = aeels( ltab, mtab, beta );

for  ien = 1 : length( enei )

  %  wavenumber of light in medium
  [ epsb, k ] = obj.epsout( enei( ien ) );
  %  Mie expressions only implemented for epsb = 1
  assert( epsb == 1 );  
  %  relative dielectric function
  epsz = obj.epsin( enei( ien ) ) / epsb;

  %  Mie coefficients 
  %    [ a, b ]   correspond to  1i * [ tE, tM ]  of Garcia [ Eqs. (20,21) ]
  [ te, tm ] = miecoefficients( k, obj.diameter, epsz, 1, ltab );
  %  correct for different prefactors due to h(+) notation of Messiah
  te = 1i * te;
  tm = 1i * tm;

  for ib = 1 : length( b )      
    %  Bessel function
    K = besselk( mtab, k * b( ib ) / ( beta * gamma ) );
    %  energy loss probability, Eq. (29)
    prob( ib, ien ) =  ...
      sum( K .^ 2 .* ( cm .* imag( tm ) + ce .* imag( te ) ) ) / k;
    %  photon loss probability, Eq. (37)   
    prad( ib, ien ) =  ...
      sum( K .^ 2 .* ( cm .* abs( tm ) .^ 2 + ce .* abs( te ) .^ 2 ) ) / k;
  end
end

%  load atomic units
misc.atomicunits;
%  convert to units of (1/eV)
prob = fine ^ 2 / ( bohr * hartree ) * prob;
prad = fine ^ 2 / ( bohr * hartree ) * prad;
