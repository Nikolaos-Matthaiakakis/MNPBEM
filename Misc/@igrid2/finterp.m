function fun = finterp( obj, x, y )
%  FINTERP - Interpolation function for points (x,y).
%
%  Usage for obj = igrid2 :
%    fun = finterp( obj, x, y )
%  Input
%    x, y       :  interpolation points (x,y)
%  Output
%    fun        :  interpolation function
%
%  Given an array V with tabulated values at positions (obj.x,obj.y) the
%  interpolated values at positions (x,y) can be computed from VI = fun(V).

%  index to grid positions
[ ~, ix ] = histc( x( : ), obj.x );  assert( all( ix ~= 0 ) );
[ ~, iy ] = histc( y( : ), obj.y );  assert( all( iy ~= 0 ) );
%  handle cases  x == max( obj.x )  or  y == max( obj.y )
ix = min( ix, numel( obj.x ) - 1 );
iy = min( iy, numel( obj.y ) - 1 );
%  bin coordinates
xx = ( x( : ) - obj.x( ix ) .' ) ./ ( obj.x( ix + 1 ) - obj.x( ix ) ) .';
yy = ( y( : ) - obj.y( iy ) .' ) ./ ( obj.y( iy + 1 ) - obj.y( iy ) ) .';

%  size of interpolation array
siz = [ numel( obj.x ), numel( obj.y ) ];
%  interpolation indices
ind = [ sub2ind( siz, ix + 0, iy + 0 ), sub2ind( siz, ix + 1, iy + 0 ),  ...
        sub2ind( siz, ix + 0, iy + 1 ), sub2ind( siz, ix + 1, iy + 1 ) ];
%  interpolation weights
w = [ ( 1 - xx ) .* ( 1 - yy ), xx .* ( 1 - yy ), ( 1 - xx ) .* yy, xx .* yy ];

%  interpolation function for bilinear interpolation
fun = @( v ) reshape( sum( w .* v( ind ), 2 ), size( x ) );
