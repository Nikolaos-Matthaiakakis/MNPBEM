function y = inthankel( obj, enei, kpar, pos, ind )
%  INTHANKEL - Integration for given k-parallel.
%
%  Usage for obj = greensubs :
%    y = intbessel( obj, enei, kpar, pos, ind )
%  Input
%    enei       :  wavelength of light in vacuum
%    kpar       :  parallel component of wavevector
%    pos        :  positions
%    ind        :  index to selected elements
%  Output
%    y          :  integrand for complex integration with Hankel functions

if ~exist( 'ind', 'var' )
  ind = 1 : numel( mul( pos.r, mul( pos.z1, pos.z2 ) ) );
end

%  wavenumber in media
[ ~, k ] = cellfun( @( eps ) ( eps( enei ) ), obj.eps );
%  parallel components
kpar1 = kpar;
kpar2 = conj( kpar );
%  perpendicular component of wavevector
kz1 = sqrt( k .^ 2 - kpar1 ^ 2 );  kz1 = kz1 .* sign( imag( kz1 + 1e-10i ) );
kz2 = sqrt( k .^ 2 - kpar2 ^ 2 );  kz2 = kz2 .* sign( imag( kz2 + 1e-10i ) );
kz1 = kz1( pos.ind1 );
kz2 = kz2( pos.ind1 );
%  reflection and transmission coefficients
[ refl1, refl1z ] = reflection( obj, enei, kpar1, pos );
[ refl2, refl2z ] = reflection( obj, enei, kpar2, pos );
  
%  Bessel functions
h0 = besselh( 0, kpar * pos.r );
h1 = besselh( 1, kpar * pos.r );

%  number of tabulated values
n = numel( find( ind ) );
%  allocate array
y = zeros( 15 * n, 1 );
%  index for output array
num = @( iname, i ) ( ( iname - 1 ) * 3 + ( i - 1 ) ) * n + ( 1 : n );

%  multiplication function
fun = @( a, b ) ( subsref( mul( a, b ), substruct( '()', { ind } ) ) );
%  names of reflection and transmission coefficients
names = fieldnames( refl2 );

%  loop over field names
for i = 1 : length( names )
  %  reflection and transmission coefficients
  [ rr1, rr1z ] = deal( refl1.( names{ i } ), refl1z.( names{ i } ) );
  [ rr2, rr2z ] = deal( refl2.( names{ i } ), refl2z.( names{ i } ) );
  %  store values in output array
  y( num( i, 1 ) ) =  ...
    0.5i * fun(       h0,   multiply( pos, rr1,   kpar1     ./ kz1 ) ) -  ...
    0.5i * fun( conj( h0 ), multiply( pos, rr2,   kpar2     ./ kz2 ) );
  y( num( i, 2 ) ) =  ...
    0.5i * fun(       h1,   multiply( pos, rr1, - kpar1 ^ 2 ./ kz1 ) ) -  ...
    0.5i * fun( conj( h1 ), multiply( pos, rr2, - kpar2 ^ 2 ./ kz2 ) );
  y( num( i, 3 ) ) =  ...
    0.5i * fun(       h0,   1i * multiply( pos, rr1z, kpar1 ) ) -  ...
    0.5i * fun( conj( h0 ), 1i * multiply( pos, rr2z, kpar2 ) );
end


function c = multiply( pos, a, b )
%  MULTIPLY - Multiply a and b.
%    Depending on the size of a and b, either the direct product a .* b or
%    the outer product a * b is computed.
    
if all( size( pos.z1 ) == size( pos.z2 ) )
  c = a .* b;
else
 c = bsxfun( @times, a, b( : ) );
 if size( c, 2 ) == 1,  c = transpose( c );  end
end
