function s = eval( obj, x, y )
%  EVAL - Evaluate shape function.
%
%  Usage for obj = quad :
%    s = eval( obj, x, y )
%  Input
%    x, y     :  quadrilateral coordinates
%  Output
%    s        :  quadrilateral shape function
      
%  reshape triangular coordinates
[ x, y ] = deal( x( : ), y( : ) );

switch obj.node
  case 4
    s = 0.25 * [ ( 1 - x ) .* ( 1 - y ), ( 1 + x ) .* ( 1 - y ),  ...
                 ( 1 + x ) .* ( 1 + y ), ( 1 - x ) .* ( 1 + y ) ];
  case 9
    %  assembly function
    fun = @( x, y )  ...
      [ x( :, 1 ) .* y( :, 1 ), x( :, 3 ) .* y( :, 1 ), x( :, 3 ) .* y( :, 3 ),  ...
        x( :, 1 ) .* y( :, 3 ), x( :, 2 ) .* y( :, 1 ), x( :, 3 ) .* y( :, 2 ),  ...
        x( :, 2 ) .* y( :, 3 ), x( :, 1 ) .* y( :, 2 ), x( :, 2 ) .* y( :, 2 ) ];       
    
    s = fun( [ 0.5 * x .* ( x - 1 ), 1 - x .^ 2, 0.5 * x .* ( 1 + x ) ],  ...
             [ 0.5 * y .* ( y - 1 ), 1 - y .^ 2, 0.5 * y .* ( 1 + y ) ] );
end
