function s = eval( obj, x, y )
%  EVAL - Evaluate shape function.
%
%  Usage for obj = tri :
%    s = eval( obj, x, y )
%  Input
%    x, y     :  triangular coordinates
%  Output
%    s        :  triangular shape function
      
%  reshape triangular coordinates
[ x, y ] = deal( x( : ), y( : ) );
%  third tringular coordinate
z = 1 - x - y;

switch obj.node
  case 3
    s = [ x, y, z ];
  case 6
    s = [ x .* ( 2 * x - 1 ), y .* ( 2 * y - 1 ),  ...
                              z .* ( 2 * z - 1 ), 4 * x .* y, 4 * y .* z, 4 * z .* x ];
end
