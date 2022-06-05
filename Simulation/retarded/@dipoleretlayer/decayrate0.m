function [ tot, rad, rad0 ] = decayrate0( obj, enei )
%  DECYRATE0 - Total and radiative decay rate for oscillating dipole above
%    layer structure (w/o nanoparticle) in units of the free-space decay
%    rate.
%
%  Usage for obj = dipoleretlayer :
%    [ tot, rad, dar0 ] = decayrate0( obj, enei )
%  Input
%    enei       :  wavelength of light in vacuum
%  Output
%    tot        :  total decay rate
%    rad        :  radiative decay rate
%    rad0       :  free-space decay rate within embedding medium

%  Within the present implementation, we compute the potentials and fields
%  for the dipole in the layer structure using finite differences.  Because
%  this approach is not overly accurate, we set TOT = RAD when the layer
%  structure consists of materials with only real dielectric functions.

%  TRUE if all dielectric functions real
ir = all( cellfun( @( eps ) isreal( eps( enei ) ), obj.layer.eps ) );
%  reflected electric field
e = subsref( field( obj, obj.dip.pt, enei, 'refl' ), substruct( '.', 'e' ) );
%  wavevector of light in vacuum
k0 = 2 * pi / enei;
%  Wigner-Weisskopf decay rate in free space
gamma = 4 / 3 * k0 ^ 3;
                                  
%  initialize decay rates for oscillating dipole
tot  = zeros( obj.dip.pt.n, size( obj.dip.dip, 3 ) );
rad0 = zeros( obj.dip.pt.n, size( obj.dip.dip, 3 ) );

%  scattering cross section
sca = scattering( farfield( obj, obj.spec, enei ) );
%  radiative decay rate
rad = reshape( sca, size( rad0 ) ) / ( 2 * pi * k0 );

for ipos = 1 : obj.dip.pt.n
for idip = 1 : size( obj.dip.dip, 3 )
    
  %  dipole moment of oscillator
  dip = obj.dip.dip( ipos, :, idip );
  
  %  refractive index
  nb = sqrt( subsref( obj.dip.pt.eps1( enei ), substruct( '()', { ipos } ) ) );
  if imag( nb ) ~= 0
    warning('MATLAB:decayrate',  ...
      'Dipole embedded in medium with complex dielectric function' );  
  end
  
  %  radiative decay rate in units of free-space decay rate
  rad( ipos, idip ) = rad( ipos, idip ) / ( 0.5 * nb * gamma );  
  %  free-space decay rate
  rad0( ipos, idip ) = nb * gamma;  
  
  %  total decay rate
  if ir
    tot( ipos, idip ) = rad( ipos, idip );
  else
    tot( ipos, idip ) = 1 +  ...
      imag( squeeze( e( ipos, :, ipos, idip ) ) * dip' ) / ( 0.5 * nb * gamma );
  end

end
end
