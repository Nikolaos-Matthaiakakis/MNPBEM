function abs = absorption( obj, enei, pol )
%  ABSORPTION - Absorption cross section for miegans objects.
%
%  Usage for obj = miegans :
%    abs = absorption( obj, enei, pol )
%  Input
%    enei       :  wavelength of light in vacuum
%    pol        :  light polarization

%  background dielectric function
epsb = obj.epsout( 0 );
%  refractive index
nb = sqrt( epsb );
%  wavevector of light
k = 2 * pi ./ enei * nb;
%  ratio of dielectric functions
epsz = obj.epsin( enei ) / epsb;

%  volume of ellipsoid
vol = 4 * pi / 3 * prod( obj.ax / 2 );
%  polarizabilities
a1 = vol / ( 4 * pi ) ./ ( obj.L1 + 1 ./ ( epsz - 1 ) );
a2 = vol / ( 4 * pi ) ./ ( obj.L2 + 1 ./ ( epsz - 1 ) );
a3 = vol / ( 4 * pi ) ./ ( obj.L3 + 1 ./ ( epsz - 1 ) );

%  absorption cross section
abs = 4 * pi * k .*  ...
    imag( a1 * pol( 1 ) + a2 * pol( 2 ) + a3 * pol( 3 ) );
