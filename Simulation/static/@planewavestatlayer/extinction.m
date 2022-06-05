function ext = extinction( obj, sig, key )
%  EXTINCTION - Extinction cross section for plane wave excitation.
%    See Dahan & Greffet, Opt. Expr. 20, A530 (2012).
%
%  Usage for obj = planewavestat :
%    ext = extinction( obj, sig )
%    ext = extinction( obj, sig, key )
%  Input
%    sig        :  compstruct object containing surface charge
%    key        :  'refl', 'trans' or 'full' for extinction of reflected or 
%                   transmitted beam, or both
%  Output
%    ext        :  extinction cross section

if ~exist( 'key', 'var' ),  key = 'full';  end
%  wavenmumber of light in vacuum
k0 = 2 * pi / sig.enei;
%  dipole moment of surface charge distribution
dip = matmul( bsxfun( @times, sig.p.pos, sig.p.area ) .', sig.sig ) .';

%  decompose electric fields of waves
[ te, tm ] = decompose( obj );
%  compute reflection and transmission coefficients
refl = fresnel( obj, sig.enei );
%  magnetic field of TM mode
tm = cross( refl.ki, tm, 2 ) / k0;

%  allocate extinction array
ext = zeros( 1, size( obj.dir, 1 ) );

%  loop over propagation directions
for i = 1 : size( obj.dir, 1 )
  %  reflected and transmitted wavevector
  [ kr, kt ] = deal( refl.kr( i, : ), refl.kt( i, : ) );
  
  %  reflected and transmitted electric field
  er = refl.re( i ) * te( i, : ) + refl.rm( i ) * cross( tm( i, : ), kr, 2 ) * k0 / dot( kr, kr );
  et = refl.te( i ) * te( i, : ) + refl.tm( i ) * cross( tm( i, : ), kt, 2 ) * k0 / dot( kt, kt );
  %  scattered fields in directions of reflected and transmitted light
  esr = efarfield( obj.spec, dip( i, : ), sig.enei, vecnormalize( kr ) );
  est = efarfield( obj.spec, dip( i, : ), sig.enei, vecnormalize( kt ) );
  %  evanescent transmitted field
  if abs( imag( kt( 3 ) ) ) > 1e-10,  est = 0 * est;  end
  
  %  extinction of reflected and transmitted beam
  extr = 4 * pi / norm( kr ) * imag( dot( er, esr ) );
  extt = 4 * pi / norm( kr ) * imag( dot( et, est ) );
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
