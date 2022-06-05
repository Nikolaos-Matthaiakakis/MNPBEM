function y = matmul( a, x )
%  MATMUL - Generalized matrix multiplication for tensors.
%  
%  The matrix multiplication is performed along the last dimension of A and
%  the first dimension of X.



if numel( a ) == 1
  %  A is scalar
  if a == 0
    y = 0;
  else
    y = a * x;
  end  
elseif numel( x ) == 1 && x == 0
  %  X is zero
  y = 0;
else
  %  A is matrix
  
  %  size of matrices
  sizx = size( x );
  siza = size( a );
  
  %  reshape A ?
  if numel( siza == 2 ) && siza( end ) ~= sizx( 1 )
    y = reshape( diag( a ) * reshape( x, sizx( 1 ), [] ), sizx );
  else
    %  size of combined matrix
    siz = [ siza( 1 : end - 1 ), sizx( 2 : end ) ];
    %  multiply matrices
    y = reshape(  ...
        reshape( a, [], siza( end ) ) * reshape( x, sizx( 1 ), [] ), siz );
  end
end
