function sp = deriv( obj, x, y, key )
%  DERIV - Derivative of shape function.
%
%  Usage for obj = tri :
%    s = deriv( obj, x, y, key )
%  Input
%    x, y     :  triangular coordinates
%    key      :  'x', 'y', 'xx', 'yy', 'xy'
%  Output
%    sp       :  derivative of triangular shape function
      
%  reshape triangular coordinates
[ x, y ] = deal( x( : ), y( : ) );

switch obj.node
  case 3
    sp = deriv3( x, y, key );
  case 6
    sp = deriv6( x, y, key );
end


function sp  = deriv3( x, ~, key )
%  DERIV3 - Derivative for 3-node triangle.

switch key
  case 'x'
    sp = [ 1, 0, - 1 ];
  case 'y'
    sp = [ 0, 1, - 1 ];
  otherwise
    sp = [ 0, 0, 0 ];
end

%  reshape output array
sp = repmat( sp, numel( x ), 1 );


function sp  = deriv6( x, y, key )
%  DERIV6 - Derivative for 6-node triangle.

z = 1 - x - y;

switch key
  case 'x'
    sp = [ 4 * x - 1, 0 * y, 1 - 4 * z, 4 * y, - 4 * y, 4 * ( z - x ) ];
  case 'y'
    sp = [ 0 * x, 4 * y - 1, 1 - 4 * z, 4 * x, 4 * ( z - y ), - 4 * x ];
  case 'xx'
    sp = repmat( [ 4, 0, 4, 0,   0, - 8 ], numel( x ), 1 );
  case 'yy'
    sp = repmat( [ 0, 4, 4, 0, - 8,   0 ], numel( x ), 1 );
  case 'xy'
    sp = repmat( [ 0, 0, 4, 4, - 4, - 4 ], numel( x ), 1 );
end
