function pot = matmul3( G, sig, name, i1, i2 )
%  MATMUL2 - Matrix multiplication.
%
%  Usage :
%    pot = matmul3( G, sig, name, i1, i2 )
%  Input
%    G       :  Green function, either matrix or structure for outer surface
%    sig     :  surface charge
%    name    :  compute matrix multiplication for sig.( name )
%    i1, i2  :  G( i1 ) * sig.( name )( i2 )
%  Output
%    pot     :  potential



if ~isstruct( G )
  %  size of output matrix
  siz = size( sig.h1 );  siz( 1 : 2 ) = [ size( G, 1 ), 1 ];
  %  G( i1 ) * h( i2 )
  pot = reshape( matmul( G( :, i1, : ), sig.( name )( :, i2, : ) ), siz );
else
  %  size of output matrix
  siz = size( sig.h1 );  siz( 1 : 2 ) = [ size( G.p, 1 ), 1 ];  
  %  surface charge and current
  switch name
    case 'h1'
      [ sig, h ] = deal( sig.sig1, sig.h1 );
    case 'h2'
      [ sig, h ] = deal( sig.sig2, sig.h2 );
  end
  %  treat parallel and perpendicular components differently
  switch i2
    case { 1, 2 }
      pot = reshape( matmul( G.p(  :, i1, : ), h( :, i2, : ) ), siz );
    case 3
      pot = reshape( matmul( G.hh( :, i1, : ), h( :, i2, : ) ), siz ) +  ...
            reshape( matmul( G.hs( :, i1, : ), sig           ), siz );
  end
end
