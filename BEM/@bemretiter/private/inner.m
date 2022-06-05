function in = inner( nvec, a, mul )
%  INNER - Fast inner product.

if numel( a ) == 1 && a == 0
  in = 0;
else
  %  inner product
  in = bsxfun( @times, squeeze( a( :, 1, : ) ), nvec( :, 1 ) ) +  ...
       bsxfun( @times, squeeze( a( :, 2, : ) ), nvec( :, 2 ) ) +  ...
       bsxfun( @times, squeeze( a( :, 3, : ) ), nvec( :, 3 ) );
   %  additional multiplication ?
   if exist( 'mul', 'var' ),  in = bsxfun( @times, in, mul );  end
end
  