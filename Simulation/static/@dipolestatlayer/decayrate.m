function [ tot, rad, rad0 ] = decayrate( obj, sig )
%  DECYRATE - Total and radiative decay rate for oscillating dipole above
%    layer structure in units of the free-space decay rate.
%
%  Usage for obj = dipolestatlayer :
%    [ nonrad, rad ] = decayrate( obj, sig )
%  Input
%    sig        :  compstruct object containing surface charge
%  Output
%    tot        :  total decay rate
%    rad        :  radiative decay rate
%    rad0       :  free-space decay rate
persistent g;

%  particle and light wavelength 
[ p, enei ] = deal( sig.p, sig.enei );
%  Green function
if isempty( g ) || ( obj.dip.pt ~= g.p1 ) || ( sig.p ~= g.p2 ) ||  ...
                   ~all( p.eps1( enei ) == g.p2.eps1( enei ) ) ||  ...
                   ~all( p.eps2( enei ) == g.p2.eps2( enei ) );
  g = compgreenstatlayer( obj.dip.pt, sig.p, obj.varargin{ : }, 'waitbar', 0 );
end

%  induced electric field
e = subsref( field( g, sig ), substruct( '.', 'e' ) );
%  wavelength of light in vacuum
k0 = 2 * pi / sig.enei;
%  Wigner-Weisskopf decay rate in free space
gamma = 4 / 3 * k0 ^ 3;

%  induced dipole moment
indip = matmul( bsxfun( @times, sig.p.pos, sig.p.area )', sig.sig );
                                  
%  dipole positions 
pt = obj.dip.pt;
%  allocate output arrays
tot  = zeros( pt.n, size( obj.dip.dip, 3 ) );
rad  = zeros( pt.n, size( obj.dip.dip, 3 ) );
rad0 = zeros( pt.n, size( obj.dip.dip, 3 ) );

for ipos = 1 : pt.n
for idip = 1 : size( obj.dip.dip, 3 )
  
  %  refractive index
  nb = sqrt( subsref( pt.eps1( sig.enei ), substruct( '()', { ipos } ) ) );
  if imag( nb ) ~= 0
    warning('MATLAB:decayrate',  ...
      'Dipole embedded in medium with complex dielectric function' );
  end
  
  %  dipole moment of oscillator
  dip = obj.dip.dip( ipos, :, idip );
  %  scattering cross section
  sca = scattering( obj.spec,  ...
    reshape( indip( :, ipos, idip ), size( dip ) ) + dip / nb ^ 2, sig.enei );  
  %  radiative decay rate in units of free-space decay rate
  rad( ipos, idip ) = ( sca / ( 2 * pi * k0 ) ) / ( 0.5 * nb * gamma );  

  %  total decay rate
  tot( ipos, idip ) = 1 + rad( ipos, idip ) +  ...
    imag( squeeze( e( ipos, :, ipos, idip ) ) * dip' ) / ( 0.5 * nb * gamma );
  %  free-space decay rate
  rad0( ipos, idip ) = nb * gamma;
end
end
