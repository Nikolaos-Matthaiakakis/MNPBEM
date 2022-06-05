function [ tot, rad, rad0 ] = decayrate( obj, sig )
%  Total decay rate for oscillating dipole
%                       in units of the free-space decay rate.
%
%  Usage for obj = dipoleret :
%    tot = decayrate( obj, sig )
%  Input
%    sig        :  compstruct object containing surface charges and currents
%  Output
%    tot        :  total decay rate
%    rad        :  radiative decay rate
%    rad0       :  free-space decay rate
persistent g;

%  particle and light wavelength 
[ p, enei ] = deal( sig.p, sig.enei );
%  Green function
if isempty( g ) || ( obj.pt ~= g.p1 ) || ( sig.p ~= g.p2 ) ||  ...
               ~all( p.eps1( enei ) == g.p2.eps1( enei ) ) ||  ...
               ~all( p.eps2( enei ) == g.p2.eps2( enei ) )
  g = compgreenret( obj.pt, sig.p, obj.varargin{ : }, 'waitbar', 0  );
end

%  induced electric field
e = subsref( field( g, sig ), substruct( '.', 'e' ) );
%  wavevector of light in vacuum
k0 = 2 * pi / sig.enei;
%  Wigner-Weisskopf decay rate in free space
gamma = 4 / 3 * k0 ^ 3;
                                  
%  decay rates for oscillating dipole
tot  = zeros( obj.pt.n, size( obj.dip, 3 ) );
rad0 = zeros( obj.pt.n, size( obj.dip, 3 ) );

%  scattering cross section
sca = scattering( obj, sig );
%  radiative decay rate
rad = reshape( sca, size( rad0 ) ) / ( 2 * pi * k0 );

for ipos = 1 : obj.pt.n
for idip = 1 : size( obj.dip, 3 )
    
  %  dipole moment of oscillator
  dip = obj.dip( ipos, :, idip );
  
  %  refractive index
  nb = sqrt( subsref( obj.pt.eps1( sig.enei ), substruct( '()', { ipos } ) ) );
  if imag( nb ) ~= 0
    warning('MATLAB:decayrate',  ...
      'Dipole embedded in medium with complex dielectric function' );  
  end
  
  %  total decay rate
  tot( ipos, idip ) = 1 +  ...
    imag( squeeze( e( ipos, :, ipos, idip ) ) * dip' ) / ( 0.5 * nb * gamma );
  %  radiative decay rate in units of free-space decay rate
  rad( ipos, idip ) = rad( ipos, idip ) / ( 0.5 * nb * gamma );
  %  free-space decay rate
  rad0( ipos, idip ) = nb * gamma;
    
end
end
