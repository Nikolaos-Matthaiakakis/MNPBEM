function pot = matmul2( G, sig, name )
%  MATMUL2 - Matrix multiplication.
%
%  Usage :
%    pot = matmul2( G, sig, name, k )
%  Input
%    G      :  Green function, either matrix or structure for outer surface
%    sig    :  surface charge
%    name   :  compute matrix multiplication for sig.( name )
%  Output
%    pot    :  potential

if ~isstruct( G )
  pot = matmul( G, sig.( name ) );
else
  switch name
    case 'sig1'
      %  G.ss * sig1 + G.sh * h1( 3 )
      pot = matmul( G.ss, sig.sig1 ) +  ...
        matmul( G.sh, reshape( sig.h1( :, 3, : ), size( sig.sig1 ) ) );
    case 'sig2'
      %  G.ss * sig2 + G.sh * h2( 3 )
      pot = matmul( G.ss, sig.sig2 ) +  ...
        matmul( G.sh, reshape( sig.h2( :, 3, : ), size( sig.sig2 ) ) );      
    case 'h1'
      siz = size( sig.h1 );  siz( 2 ) = 1;
      %  [ G.p * h1( 1 ), G.p * h1( 2 ), G.hh * h1( 2 ) + G.hs * sig1 ]
      pot = cat( 2, matmul( G.p,  reshape( sig.h1( :, 1, : ), siz ) ),   ...
                    matmul( G.p,  reshape( sig.h1( :, 2, : ), siz ) ),   ...
                    matmul( G.hh, reshape( sig.h1( :, 3, : ), siz ) ) +  ...
                    matmul( G.hs, reshape( sig.sig1,          siz ) ) );
    case 'h2'
      siz = size( sig.h2 );  siz( 2 ) = 1;
      %  [ G.p * h2( 1 ), G.p * h2( 2 ), G.hh * h2( 2 ) + G.hs * sig2 ]
      pot = cat( 2, matmul( G.p,  reshape( sig.h2( :, 1, : ), siz ) ),   ...
                    matmul( G.p,  reshape( sig.h2( :, 2, : ), siz ) ),   ...
                    matmul( G.hh, reshape( sig.h2( :, 3, : ), siz ) ) +  ...
                    matmul( G.hs, reshape( sig.sig2,          siz ) ) );
  end
end


