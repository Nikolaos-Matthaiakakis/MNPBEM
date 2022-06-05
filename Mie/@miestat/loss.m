function prob = loss( obj, b, enei, beta )
%  LOSS - Energy loss of fast electron in vicinity of dielectric sphere.
%    see, F. J. Garcia de Abajo, Rev. Mod. Phys. 82, 209 (2010, Eq. (31).
%
%  Usage for obj = miestat :
%    prob = loss( obj, b, enei, beta )
%  Input
%    b      :  impact parameter
%    enei   :  wavelength of light in vacuum
%    beta   :  electron velocity in units of speed of light (default 0.7)
%  Output
%    prob   :  EELS probability

%  make sure that electron trajectory does not penetrate sphere
assert( all( b > 0 ) );

%  radius of sphere
a = 0.5 * obj.diameter;
%  add sphere radius to impact parameter
b = a + b;

%  electron velocity in units of speed of light
if ~exist( 'beta', 'var' );  beta = 0.7;  end

% EELS probability
prob = zeros( length( b ), length( enei ) );
%  spherical harmonics
[ l, m ] = sphtable( max( obj.ltab( : ) ), 'full' );

for  ien = 1 : length( enei )

  %  wavenumber of light in medium
  [ epsb, k ] = obj.epsout( enei( ien ) );  
  %  Mie expressions only implemented for epsb = 1
  assert( epsb == 1 );
  %  relative dielectric function
  epsz = obj.epsin( enei( ien ) ) / epsb;
  
  %  polarizability of sphere
  alpha = ( l * epsz - l ) ./ ( l * epsz + l + 1 ) * a .^ 3;
  %  prefactor
  fac = ( k * a / beta ) .^ ( 2 * l ) ./ ( factorial( l + m ) .* factorial( l - m ) );

  for ib = 1 : length( b )      
    %  Bessel function
    K = besselk( m, k * b( ib ) / beta );
    %  energy loss probability
    prob( ib, ien ) = sum( fac .* K .^ 2 .* imag( alpha ) );
  end
end

%  load atomic units
misc.atomicunits;
%  convert to units of (1/eV)
prob = 4 * fine ^ 2 / ( pi * hartree * bohr * beta ^ 2 * a ^ 2 ) * prob;
