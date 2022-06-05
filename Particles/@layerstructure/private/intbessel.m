function y = intbessel( obj, enei, kpar, pos, ind )
%  INTBESSEL - Integration for given k-parallel.
%
%  Usage for obj = greensubs :
%    y = intbessel( obj, enei, kpar, pos, ind )
%  Input
%    enei       :  wavelength of light in vacuum
%    kpar       :  parallel component of wavevector
%    pos        :  positions
%    ind        :  index to selected elements
%  Output
%    y          :  integrand for complex integration with Bessel functions

if ~exist( 'ind', 'var' )
  ind = 1 : numel( mul( pos.r, mul( pos.z1, pos.z2 ) ) );
end

%  wavenumber in media
[ ~, k ] = cellfun( @( eps ) ( eps( enei ) ), obj.eps );
%  perpendicular component of wavevector
kz = sqrt( k .^ 2 - kpar ^ 2 );  
kz = kz .* sign( imag( kz + 1e-10i ) );
kz = kz( pos.ind1 );
%  reflection and transmission coefficients
[ refl, reflz ] = reflection( obj, enei, kpar, pos );
  
%  Bessel functions
j0 = besselj( 0, kpar * pos.r );
j1 = besselj( 1, kpar * pos.r );

%  number of tabulated values
n = numel( find( ind ) );
%  allocate array
y = zeros( 15 * n, 1 );
%  index for output array
num = @( iname, i ) ( ( iname - 1 ) * 3 + ( i - 1 ) ) * n + ( 1 : n );

%  multiplication function
fun = @( a, b ) ( subsref( mul( a, b ), substruct( '()', { ind } ) ) );
%  names of reflection and transmission coefficients
names = fieldnames( refl );

%  loop over field names
for i = 1 : length( names )
  %  reflection and transmission coefficients
  [ rr, rrz ] = deal( refl.( names{ i } ), reflz.( names{ i } ) );
  %  store values in output array
  y( num( i, 1 ) ) = 1i * fun( j0, multiply( pos, rr,   kpar     ./ kz ) );
  y( num( i, 2 ) ) = 1i * fun( j1, multiply( pos, rr, - kpar ^ 2 ./ kz ) );
  y( num( i, 3 ) ) = 1i * fun( j0, 1i * multiply( pos, rrz, kpar ) );
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
