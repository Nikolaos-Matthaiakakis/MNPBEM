function [ te, tm ] = decompose( obj )
%  Decompose - Decompose fields into TE and TM modes.
%
%  Usage for obj = planewavestatlayer :
%    [ te, tm ] = decompose( obj )
%  Output
%    te     :  polarization of TE modes
%    tm     :  polarization of TM modes

%  extract polarization and propagation directions
[ pol, dir ] = deal( obj.pol, obj.dir );
%  electric fields and wavenumbers
[ ex, ey ] = deal( pol( :, 1 ), pol( :, 2 ) );
[ kx, ky ] = deal( dir( :, 1 ), dir( :, 2 ) );
%  parallel wavenumber component
kt = max( sqrt( kx .^ 2 + ky .^ 2 ), eps );
%  normal vector
nvec = [ ky ./ kt, - kx ./ kt, 0 * kx ];

%  TE component
te = bsxfun( @times, nvec, ( ky .* ex - kx .* ey ) ./ kt );
tm = pol - te;
