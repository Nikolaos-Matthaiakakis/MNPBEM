function a = spdiag( a )
%  SPDIAG - Put array values on the diagonal of a sparse matrix.

n = length( a );
a = spdiags( a( : ), 0, n, n );
