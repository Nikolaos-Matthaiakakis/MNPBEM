function ext = extinction( obj, sig, key )
%  EXTINCTION - Extinction cross section for plane wave excitation.
%    See Lytle et al., Phys. Rev. E 71, 056610 (2005).
%
%  Usage for obj = planewaveretlayer :
%    ext = extinction( obj, sig )
%    ext = extinction( obj, sig, key )
%  Input
%    sig        :  compstruct object containing surface charge
%    key        :  'refl', 'trans' or 'full' for extinction of reflected or 
%                   transmitted beam, or both
%  Output
%    ext        :  extinction cross section

if ~exist( 'key', 'var' ),  key = 'full';  end
%  allocate output array
ext = zeros( 1, size( obj.dir, 1 ) );
%  reflected and transmitted fields and wavevectors
[ e, k ] = efresnel( obj.layer, obj.pol, obj.dir, sig.enei );

%  loop over propagation directions
for i = 1 : size( obj.dir, 1 )
  
  %  scattered far fields for reflection
  esr = farfield( obj.spec, sig, vecnormalize( k.r( i, : ) ) );  
  esr = squeeze( esr.e( 1, :, i ) );
  %  scattered far fields for transmission
  if abs( imag( k.t( i, 3 ) ) ) > 1e-10
    %  evanescent field
    est = [ 0, 0, 0 ]; 
  else
    est = farfield( obj.spec, sig, vecnormalize( k.t( i, : ) ) );  
    est = squeeze( est.e( 1, :, i ) );
  end
  
  %  extinction of reflected and transmitted beam
  extr = 4 * pi / norm( k.r( i, : ) ) * imag( dot( e.r( i, : ), esr ) );
  extt = 4 * pi / norm( k.r( i, : ) ) * imag( dot( e.t( i, : ), est ) );
  %  set output
  switch key
    case 'refl'
      ext( i ) = extr;
    case 'trans'
      ext( i ) = extt;
    otherwise
      ext( i ) = extr + extt;
  end
end
