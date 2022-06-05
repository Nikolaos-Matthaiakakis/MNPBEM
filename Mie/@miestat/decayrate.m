function [ tot, rad ] = decayrate( obj, enei, z )
%  Total and radiative decay rate for oscillating dipole.
%    Scattering rates are given in units of the free-space decay rate.
%
%  Usage for obj = miestat :
%    [ tot, rad ] = decayrate( obj, enei, pos )
%  Input
%    enei       :  wavelength of light in vacuum (only one value)
%    z          :  dipole positions on z axis
%  Output
%    tot        :      total scattering rate for dipole orientations x and z
%    rad        :  radiative scattering rate for dipole orientations x and z

assert( length( enei ) == 1 );

%  background dielectric function
epsb = obj.epsout( 0 );
%  refractive index
nb = sqrt( epsb );

%  free space radiative lifetime (Wigner-Weisskopf)
gamma = 4 / 3 * nb * ( 2 * pi / enei ) ^ 3;    
%  ratio of dielectric functions
epsz = obj.epsin( enei ) / epsb;

%  total and radiative scattering rate
tot = zeros( length( z ), 2 );
rad = zeros( length( z ), 2 );

%  loop over dipole positions and orientation
for iz   = 1 : length( z )
for idip = 1 : 2
    
  %  dipole orientation
  dip = subsref( [ 1, 0, 0; 0, 0, 1 ], substruct( '()', { idip, ':' } ) );
  %  position of dipole
  pos = [ 0, 0, z( iz ) ] / obj.diameter;   
  %  spherical harmonics coefficients for dipole
  adip = adipole( pos, dip, obj.ltab, obj.mtab );

  %  induced dipole moment of sphere
  indip = dipole( obj.ltab, obj.mtab, adip, 1, epsz );
  %  radiative decay rate (in units of free decay rate)
  rad( iz, idip ) = norm( dip + indip ) ^ 2;
  
  %  induced electric field
  efield = field( obj.ltab, obj.mtab, pos, adip, 1, epsz ) / ( epsb * obj.diameter ^ 3 );
  %  total decay rate
  tot( iz, idip ) = rad( iz, idip ) + imag( efield * dip' ) / ( gamma / 2 );
    
end
end
  