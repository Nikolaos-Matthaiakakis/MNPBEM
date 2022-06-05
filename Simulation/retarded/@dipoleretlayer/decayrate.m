function [ tot, rad, rad0 ] = decayrate( obj, sig )
%  DECYRATE - Total and radiative decay rate for oscillating dipole above
%    layer structure in units of the free-space decay rate.
%
%  Usage for obj = dipoleretlayer :
%    [ nonrad, rad ] = decayrate( obj, sig )
%  Input
%    sig        :  compstruct object containing surface charge
%  Output
%    tot        :  total decay rate
%    rad        :  radiative decay rate
%    rad0       :  free-space decay rate within embedding medium
persistent g;

%%  Green function
if isempty( g ) || ( obj.dip.pt ~= g.p1 ) || ( sig.p ~= g.p2 )
  g = compgreenretlayer( obj.dip.pt, sig.p, obj.varargin{ : }, 'waitbar', 0  );
end

%%  auxiliary quantities
%  induced electric field
e = subsref( field( g, sig ) +  ...
             field( obj, obj.dip.pt, sig.enei, 'refl' ), substruct( '.', 'e' ) );
%  wavevector of light in vacuum
k0 = 2 * pi / sig.enei;
%  Wigner-Weisskopf decay rate in free space
gamma = 4 / 3 * k0 ^ 3;
                                  
%%  decay rates for oscillating dipole
tot  = zeros( obj.dip.pt.n, size( obj.dip.dip, 3 ) );
rad0 = zeros( obj.dip.pt.n, size( obj.dip.dip, 3 ) );

%  scattering cross section
sca = scattering( obj.spec.farfield( sig ) + farfield( obj, obj.spec, sig.enei ) );
%  radiative decay rate
rad = reshape( sca, size( rad0 ) ) / ( 2 * pi * k0 );

for ipos = 1 : obj.dip.pt.n
for idip = 1 : size( obj.dip.dip, 3 )
    
  %  dipole moment of oscillator
  dip = obj.dip.dip( ipos, :, idip );
  
  %  refractive index
  nb = sqrt( subsref( obj.dip.pt.eps1( sig.enei ), substruct( '()', { ipos } ) ) );
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
