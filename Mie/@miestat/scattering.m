function sca = scattering( obj, enei )
%  SCATTERING - Scattering cross section for miestat objects.
%
%  Usage for obj = miestat :
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

%  sphere radius
a = obj.diameter / 2;
%  polarizability of sphere ( see van de Hulst, Sec. 6.31 )
alpha = ( epsz - 1 ) ./ ( epsz + 2 ) * a ^ 3;

%  scattering cross section
sca = 8 * pi / 3 * k .^ 4 .* abs( alpha ) .^ 2;
