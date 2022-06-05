function refl = fresnel( obj, enei )
%  FRESNEL - Fresnel coefficients for TE and TM modes.
%    Equations taken from Chew, Waves and fields in inhomogeneous media
%    (IEEE Press, New York, 1995)
%
%  Usage for obj = planewavestatlayer :
%    refl = fresnel( obj, enei )
%  Input
%    enei       :  wavelength of light in vacuum
%  Output
%    refl.te    :  transmission coefficient for TE mode
%    refl.re    :  reflection   coefficient for TE mode
%    refl.tm    :  transmission coefficient for TM mode
%    refl.rm    :  reflection   coefficient for TM mode
%    refl.ki    :  wavevector of incoming field
%    refl.kr    :  wavevector of reflected field 
%    refl.kt    :  wavevector of transmitted field

%  dielectric functions
[ eps1, k1 ] = obj.layer.eps{ 1 }( enei );
[ eps2, k2 ] = obj.layer.eps{ 2 }( enei );

%  extract propagation direction
dir = obj.dir;
%  allocate arrays for reflection coefficients
re = zeros( 1, size( dir, 1 ) );  te = zeros( 1, size( dir, 1 ) );
rm = zeros( 1, size( dir, 1 ) );  tm = zeros( 1, size( dir, 1 ) );
%  allocate array for wavevectors
[ ki, kr, kt ] =  ...
  deal( zeros( size( dir ) ), zeros( size( dir ) ), zeros( size( dir ) ) );

%  loop over propagation directions
for i = 1 : size( dir, 1 )
  
  %  downgoing wave
  if dir( i, 3 ) < 0
    %  z-components of wavevector
    k1z = - k1 * dir( i, 3 );
    k2z = sqrt( k2 ^ 2 - k1 ^ 2 + k1z ^ 2 );    
    %  proper sign for evanescent fields
    if imag( k2z ) < 0,  k2z = conj( k2z );  end
    %  Fresnel coefficients for TE modes, Eq. (2.1.13)
    re( i ) = ( k1z - k2z ) / ( k1z + k2z );
    te( i ) =     2 * k1z   / ( k1z + k2z );
    %  Fresnel coefficients for TM modes, Eq. (2.1.4)
    rm( i ) = ( eps2 * k1z - eps1 * k2z ) / ( eps2 * k1z + eps1 * k2z );
    tm( i ) =            2 * eps2 * k1z   / ( eps2 * k1z + eps1 * k2z );
    %  wavevector for incoming, reflected, and transmitted wave
    ki( i, : ) = k1 * dir( i, : );
    kr( i, : ) = [ ki( i, 1 : 2 ),   k1z ];
    kt( i, : ) = [ ki( i, 1 : 2 ), - k2z ];

  %  upgoing wave
  else
    %  z-components of wavevector
    k2z = k2 * dir( i, 3 );
    k1z = sqrt( k1 ^ 2 - k2 ^ 2 + k2z ^ 2 ); 
    %  proper sign for evanescent fields
    if imag( k1z ) < 0,  k1z = conj( k1z );  end    
    %  Fresnel coefficients for TE modes, Eq. (2.1.13)
    re( i ) = ( k2z - k1z ) / ( k2z + k1z );
    te( i ) =     2 * k2z   / ( k2z + k1z ); 
    %  Fresnel coefficients for TM modes, Eq. (2.1.4)
    rm( i ) = ( eps1 * k2z - eps2 * k1z ) / ( eps1 * k2z + eps2 * k1z );
    tm( i ) =            2 * eps1 * k2z   / ( eps1 * k2z + eps2 * k1z );    
    %  wavevector for incoming, reflected, and transmitted wave
    ki( i, : ) = k2 * dir( i, : );
    kr( i, : ) = [ ki( i, 1 : 2 ), - k2z ];
    kt( i, : ) = [ ki( i, 1 : 2 ),   k1z ];
  end  
end

%  save reflection and transmission coefficients
refl = struct( 're', re, 'te', te,  ...
               'rm', rm, 'tm', tm, 'ki', ki, 'kr', kr, 'kt', kt );
