function out = outer( nvec, val, mul )
%  OUTER - Fast outer product between vector and matrix.

if numel( val ) == 1 && val == 0
  out = 0;
else
  siz = [ size( val, 1 ), 1, size( val, 2 ) ];
  %  additional multiplication ?
  if exist( 'mul', 'var' ),  val = bsxfun( @times, val, mul );  end
  %  outer product
  out = cat( 2,  ...
    reshape( bsxfun( @times, val, nvec( :, 1 ) ), siz ),  ...
    reshape( bsxfun( @times, val, nvec( :, 2 ) ), siz ),  ...
    reshape( bsxfun( @times, val, nvec( :, 3 ) ), siz ) );
end
  