function a = outer( nvec, val, mul )
%  OUTER - Outer product between vector and tensor.
%
%  a( i, 1, j, ... ) = nvec( i, 1 ) * val( i, j, ... )
%  a( i, 2, j, ... ) = nvec( i, 2 ) * val( i, j, ... )
%  a( i, 3, j, ... ) = nvec( i, 3 ) * val( i, j, ... )
%
%  If an additional matrix is provided, val -> mul * val prior to the outer
%  product.

if exist( 'mul', 'var' )
  val = matmul( mul, val );
end

if size( nvec, 1 ) ~= size( val, 1 )
  a = 0;
else
  siz = size( val );
  siz = [ siz( 1 ), 1, siz( 2 : end ) ];

  a = cat( 2,                                      ...
      resh( matmul( nvec( :, 1 ), val ), siz ),    ...
      resh( matmul( nvec( :, 2 ), val ), siz ),    ...
      resh( matmul( nvec( :, 3 ), val ), siz ) );
end

if all( a( : ) == 0 )
  a = 0;
end


function a = resh( a, siz )
%  RESH - Reshape vector component.

if numel( a ) == 1 && a == 0
  a = zeros( siz ); 
else
  a = reshape( a, siz );
end