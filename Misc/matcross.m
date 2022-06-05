function c = matcross( a, b )
%  MATCROSS - Generalized cross product for tensors.
%  
%  Usage :
%    c = matcross( a, b )
%  Input
%    a      :  vector of dimensions [ n x 3 ]
%    b      :  tensor of dimensions [ n x 3 x ... ]
%  Output
%    c      :  cross product of A and B of same dimensions as B

%  size of tensor
siz = size( b );  siz( 2 ) = 1;
%  multiplication function
fun = @( i, j )  ...
  reshape( bsxfun( @times, squeeze( b( :, j, : ) ), a( :, i ) ), siz );

%  cross product
c = cat( 2, fun( 2, 3 ) - fun( 3, 2 ),  ...
            fun( 3, 1 ) - fun( 1, 3 ),  ...
            fun( 1, 2 ) - fun( 2, 1 ) );
          