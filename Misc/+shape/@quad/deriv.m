function sp = deriv( obj, x, y, key )
%  DERIV - Derivative of shape function.
%
%  Usage for obj = quad :
%    s = deriv( obj, x, y, key )
%  Input
%    x, y     :  quadrilateral coordinates
%    key      :  'x', 'y', 'xx', 'yy', 'xy'
%  Output
%    sp       :  derivative of quadrilateral shape function
      
%  reshape quadrilateral coordinates
[ x, y ] = deal( x( : ), y( : ) );

switch obj.node
  case 4
    sp = deriv4( x, y, key );
  case 9
    sp = deriv9( x, y, key );
end


function sp  = deriv4( x, y, key )
%  DERIV4 - Derivative for 4-node quadrilateral.

switch key
  case 'x'
    sp = 0.25 * [ - ( 1 - y ),   ( 1 - y ), ( 1 + y), - ( 1 + y ) ];
  case 'y'
    sp = 0.25 * [ - ( 1 - x ), - ( 1 + x ), ( 1 + x ),  ( 1 - x ) ];
  case 'xy'
    sp = repmat( 0.25 * [ 1, - 1, 1, - 1 ], numel( x ), 1 );
  otherwise
    sp = repmat(         [ 0,  0, 0,   0 ], numel( x ), 1 );
end


function sp  = deriv9( x, y, key )
%  DERIV9 - Derivative for 9-node quadrilateral.

%  shape functions
sx0 = [ 0.5 * x .* ( x - 1 ), 1 - x .^ 2, 0.5 * x .* ( 1 + x ) ];
sy0 = [ 0.5 * y .* ( y - 1 ), 1 - y .^ 2, 0.5 * y .* ( 1 + y ) ];
%  derivatives of shape functions
sx1 = [ x - 0.5, - 2 * x, x + 0.5 ];  sx2 = repmat( [ 1, - 2, 1 ], numel( x ), 1 );
sy1 = [ y - 0.5, - 2 * y, y + 0.5 ];  sy2 = repmat( [ 1, - 2, 1 ], numel( y ), 1 );
%  assembly function
fun = @( x, y )  ...
  [ x( :, 1 ) .* y( :, 1 ), x( :, 3 ) .* y( :, 1 ), x( :, 3 ) .* y( :, 3 ),  ...
    x( :, 1 ) .* y( :, 3 ), x( :, 2 ) .* y( :, 1 ), x( :, 3 ) .* y( :, 2 ),  ...
    x( :, 2 ) .* y( :, 3 ), x( :, 1 ) .* y( :, 2 ), x( :, 2 ) .* y( :, 2 ) ];   

switch key
  case 'x'
    sp = fun( sx1, sy0 );
  case 'y'
    sp = fun( sx0, sy1 );
  case 'xx'
    sp = fun( sx2, sy0 );
  case 'yy'
    sp = fun( sx0, sy2 );
  case 'xy'
    sp = fun( sx1, sy1 );
end
