function sca = scattering( obj, enei )
%  SCATTERING - Scattering cross section for mieret objects.
%
%  Usage for obj = mieret :
%    sca = scattering( obj, enei )
%  Input
%    enei       :  wavelength of light in vacuum

%  background dielectric function
epsb = obj.epsout( 0 );
%  refractive index
nb = sqrt( epsb );
%  wavevector of light
k = 2 * pi ./ enei * nb;
%  ratio of dielectric functions
epsz = obj.epsin( enei ) / epsb;

%  scattering cross section
sca = zeros( size( enei ) );
%  find unique value for angular momentum degrees
[ l, ind ] = unique( obj.ltab );  

for i = 1 : length( enei )
  %  Mie coefficients 
  [ a, b ] = miecoefficients( k( i ), obj.diameter, epsz( i ), 1, obj.ltab );
  %  scattering cross section
  sca( i ) = 2 * pi / k( i ) ^ 2 *  ...
      ( 2 * l' + 1 ) * ( abs( a( ind ) ) .^ 2 + abs( b( ind ) ) .^ 2 );    
end
