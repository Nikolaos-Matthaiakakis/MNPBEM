function val = inner( nvec, a, mul )
%  INNER - Inner product between a vector and a matrix or tensor.
%
%  The generalized dot product is defined with respect to the second
%  dimension.  If an additional mul object is provided, a -> mul * a 
%  is performed prior to the inner product.

if size( nvec, 1 ) ~= size( a, 1 )
  val = 0;
else

  if exist( 'mul', 'var' )
    a = matmul( mul, a );
  end
  
  if ndims( a ) == 2
    val = dot( nvec, a, 2 );
  else
    siz = size( a );      
    val = reshape( dot( repmat( nvec, [ 1, 1, siz( 3 : end ) ] ), a, 2 ),  ...
                                  [ siz( 1 ), siz( 3 : end ) ] );
  end
end


