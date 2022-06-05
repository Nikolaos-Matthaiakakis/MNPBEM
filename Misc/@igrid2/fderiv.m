function fun = fderiv( obj, x, y, dir )
%  FDERIV - Derivative function for points (x,y).
%    Given a bilinear interpolation of a tabulated 2d function, FDERIV
%    returns a function handle for the function derivative along a given
%    direction.
%
%  Usage for obj = igrid2 :
%    fun = fderiv( obj, x, y, dir )
%  Input
%    x, y       :  interpolation points (x,y)
%    dir        :  derivative direction (1 for x, 2 for y)
%  Output
%    fun        :  derivative function
%
%  Given an array V with tabulated values at positions (obj.x,obj.y) the
%  derivative of the interpolation function at positions (x,y) an along
%  direction DIR can be computed from VI = fun(V).

%  index to grid positions
[ ~, ix ] = histc( x( : ), obj.x );  assert( all( ix ~= 0 ) );
[ ~, iy ] = histc( y( : ), obj.y );  assert( all( iy ~= 0 ) );
%  handle cases  x == max( obj.x )  or  y == max( obj.y )
ix = min( ix, numel( obj.x ) - 1 );
iy = min( iy, numel( obj.y ) - 1 );
%  bin sizes and bin coordinates
hx = ( obj.x( ix + 1 ) - obj.x( ix ) ) .';  xx = ( x( : ) - obj.x( ix ) .' ) ./ hx;
hy = ( obj.y( iy + 1 ) - obj.y( iy ) ) .';  yy = ( y( : ) - obj.y( iy ) .' ) ./ hy;

%  size of interpolation array
siz = [ numel( obj.x ), numel( obj.y ) ];
%  interpolation indices
ind = [ sub2ind( siz, ix + 0, iy + 0 ), sub2ind( siz, ix + 1, iy + 0 ),  ...
        sub2ind( siz, ix + 0, iy + 1 ), sub2ind( siz, ix + 1, iy + 1 ) ];
      
%  interpolation weights for bilinear interpolation
%     [ ( 1 - xx ) .* ( 1 - yy ), xx .* ( 1 - yy ), ( 1 - xx ) .* yy, xx .* yy ];
%  derivative of interpolation weights
switch dir
  case 1
    w = [ - ( 1 - yy ) .* hx, ( 1 - yy ) .* hx, - yy .* hx, yy .* hx ];
  case 2
    w = [ - ( 1 - xx ) .* hy, - xx .* hy, ( 1 - xx ) .* hy, xx .* hy ];
end
%  derivative for interpolation function
fun = @( v ) reshape( sum( w .* v( ind ), 2 ), size( x ) );
