function [ rad, rad0 ] = radiative( obj, field )
%  Radiative decay rate for oscillating dipole
%                       in units of the free-space decay rate.
%
%  Usage for obj = dipoleret  :
%    rad = obj.radiative( field )
%  Input
%    field      :  electromagnetic fields at infinity
%  Output
%    tot        :  radiative decay rate
%    rad0       :  free-space decay rate

%  dielectric function
epsb = reshape( obj.dip.pt.eps1( field.enei ), [], 1 );
%  refractive index
nb = sqrt( epsb ); 

if imag( nb ) ~= 0
  warning('MATLAB:decayrate',  ...
    'Dipole embedded in medium with complex dielectric function' );  
end

%  wavenumber of light in vacuum
k0 = 2 * pi / field.enei;
%  Wigner-Weisskopf decay rate in free space
rad0 = nb * 4 / 3 * k0 ^ 3;    

%  power emitted by oscillating dipole
p = scattering( field );
%  wavenumber in medium
k = nb * k0;
%  transform from emitted power to scattering rate
rad = p ./ repmat( 2 * pi * k .* epsb .* rad0, 1, size( field.e, 4 ) ); 
