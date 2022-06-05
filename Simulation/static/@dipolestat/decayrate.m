function [ tot, rad, rad0 ] = decayrate( obj, sig )
%  Total and radiative decay rate for oscillating dipole
%                       in units of the free-space decay rate.
%
%  Usage for obj = dipolestat :
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
if isempty( g ) || ( obj.pt ~= g.p1 ) || ( sig.p ~= g.p2 ) ||  ...
               ~all( p.eps1( enei ) == g.p2.eps1( enei ) ) ||  ...
               ~all( p.eps2( enei ) == g.p2.eps2( enei ) )
  g = compgreenstat( obj.pt, sig.p, obj.varargin{ : }, 'waitbar', 0 );
end

%  induced electric field
e = subsref( field( g, sig ), substruct( '.', 'e' ) );
%  Wigner-Weisskopf decay rate in free space
gamma = 4 / 3 * ( 2 * pi / sig.enei ) ^ 3;    

%  induced dipole moment
indip = matmul( bsxfun( @times, sig.p.pos, sig.p.area )', sig.sig );
                                  
%  decay rates for oscillating dipole
tot  = zeros( obj.pt.n, size( obj.dip, 3 ) );
rad  = zeros( obj.pt.n, size( obj.dip, 3 ) );
rad0 = zeros( obj.pt.n, size( obj.dip, 3 ) );

for ipos = 1 : obj.pt.n
for idip = 1 : size( obj.dip, 3 )
  
  %  refractive index
  nb = sqrt( subsref( obj.pt.eps1( sig.enei ), substruct( '()', { ipos } ) ) );
  if imag( nb ) ~= 0
    warning('MATLAB:decayrate',  ...
      'Dipole embedded in medium with complex dielectric function' );
  end
  
  %  dipole moment of oscillator
  dip = obj.dip( ipos, :, idip );
  %  radiative decay rate
  %    DIP is the transition dipole moment for the dipole in vacuum, which
  %    is screened by the dielectric function of the embedding medium
  rad( ipos, idip ) =  norm( nb .^ 2 * indip( :, ipos, idip ) .' + dip ) ^ 2;
  
  %  total decay rate
  tot( ipos, idip ) = 1 +  ...
    imag( squeeze( e( ipos, :, ipos, idip ) ) * dip' ) / ( 0.5 * nb * gamma );
  %  free-space decay rate
  rad0( ipos, idip ) = nb * gamma;
end
end
