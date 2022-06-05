function s = shapefunction( p, ind )
%  SHAPEFUNCTION - Shape function for boundary element of particle.
%  
%  Usage :
%    s = shapefunction( p, ind )
%  Input
%    p      :  COMPARTICLE object
%    ind    :  index to boundary element
%  Output
%    s      :  array of shape functions

%  integration rule
quad = p.quad;

%  triangular elements
if isnan( p.faces( ind, end ) )
  %  triangle coordinates
  [ x, y ] = deal( quad.x( : ), quad.y( : ) );
  %  shape functions for triangle
  s = [ x, y, 1 - x - y ];
else
  %  adapt integration points to quadrilateral
  pos = quad( [ - 1, - 1, 0 ], [ 1, - 1, 0 ], [ 1, 1, 0 ], [ - 1, 1, 0 ] );
  %  quadrilateral coordinates
  [ x, y ] = deal( pos( :, 1 ), pos( :, 2 ) );
  %  shape functions for quadrilateral
  s = 0.25 * [ ( 1 - x ) .* ( 1 - y ), ( 1 + x ) .* ( 1 - y ),  ...
               ( 1 + x ) .* ( 1 + y ), ( 1 - x ) .* ( 1 + y ) ];
end
