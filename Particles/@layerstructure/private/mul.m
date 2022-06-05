function c = mul( a, b )
%  MUL - Mutliplication between arrays.
%
%  Size of a        Size of b       Size of c
%  siz              siz             siz
%  siza             sizb ~= siza    [ siza, sizb ]

%  size of matrices a and b
siza = size( a );
sizb = size( b );

if numel( siza ) == numel( sizb ) && all( siza == sizb )
  c = a .* b;
else
  if siza( end ) == 1,  siza = siza( 1 : end - 1 );  end
  if sizb(   1 ) == 1,  sizb = sizb( 2 : end     );  end
  %  size of c
  siz = [ siza, sizb ];
  %  multiplication
  c = reshape( reshape( a, [], 1 ) * reshape( b, 1, [] ), siz );
end
