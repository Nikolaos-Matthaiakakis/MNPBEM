function [ tot, rad, rad0 ] = decayrate0( obj, enei )
%  DECYRATE - Total and radiative decay rate for oscillating dipole above
%    layer structure in units of the free-space decay rate.
%
%  Usage for obj = dipolestatlayer :
%    [ nonrad, rad ] = decayrate( obj, sig )
%    [ tot, rad ] = decayrate0( obj, enei )
%  Input
%    enei       :  wavelength of light in vacuum
%  Output
%    tot        :  total decay rate
%    rad        :  radiative decay rate
%    rad0       :  free-space decay rate within embedding medium

%  TRUE if all dielectric functions real
ir = all( cellfun( @( eps ) isreal( eps( enei ) ), obj.layer.eps ) );
%  induced electric field
e = subsref( field2( obj, obj.dip.pt, enei ), substruct( '.', 'e' ) );
%  wavelength of light in vacuum
k0 = 2 * pi / enei;
%  Wigner-Weisskopf decay rate in free space
gamma = 4 / 3 * k0 ^ 3;
                                  
%  dipole positions 
pt = obj.dip.pt;
%  allocate output arrays
tot  = zeros( pt.n, size( obj.dip.dip, 3 ) );
rad  = zeros( pt.n, size( obj.dip.dip, 3 ) );
rad0 = zeros( pt.n, size( obj.dip.dip, 3 ) );

for ipos = 1 : pt.n
for idip = 1 : size( obj.dip.dip, 3 )
  
  %  refractive index
  nb = sqrt( subsref( pt.eps1( enei ), substruct( '()', { ipos } ) ) );
  if imag( nb ) ~= 0
    warning('MATLAB:decayrate',  ...
      'Dipole embedded in medium with complex dielectric function' );
  end
  
  %  dipole moment of oscillator
  dip = obj.dip.dip( ipos, :, idip );
  %  scattering cross section
  sca = scattering( obj.spec, dip / nb ^ 2, enei );  
  %  radiative decay rate in units of free-space decay rate
  rad( ipos, idip ) = ( sca / ( 2 * pi * k0 ) ) / ( 0.5 * nb * gamma );  
  %  free-space decay rate
  rad0( ipos, idip ) = nb * gamma;  

  %  total decay rate
  if ir
    tot( ipos, idip ) = rad( ipos, idip );
  else
    tot( ipos, idip ) = rad( ipos, idip ) +  ...
      imag( squeeze( e( ipos, :, ipos, idip ) ) * dip' ) / ( 0.5 * nb * gamma );
  end
 
end
end
