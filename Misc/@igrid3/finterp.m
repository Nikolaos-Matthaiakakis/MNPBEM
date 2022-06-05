function fun = finterp( obj, x, y, z )
%  FINTERP - Interpolation function for points (x,y,z).
%
%  Usage for obj = igrid3 :
%    fun = finterp( obj, x, y, z )
%  Input
%    x, y,z     :  interpolation points (x,y,z)
%  Output
%    fun        :  interpolation function
%
%  Given an array V with tabulated values at positions (obj.x,obj.y,obj.z)
%  the interpolated values at positions (x,y,z) can be computed from 
%  VI = fun(V).

%  index to grid positions
[ ~, ix ] = histc( x( : ), obj.x );  assert( all( ix ~= 0 ) );
[ ~, iy ] = histc( y( : ), obj.y );  assert( all( iy ~= 0 ) );
[ ~, iz ] = histc( z( : ), obj.z );  assert( all( iz ~= 0 ) );
%  handle case  x == max( obj.x )  or similar for y, z
ix = min( ix, numel( obj.x ) - 1 );
iy = min( iy, numel( obj.y ) - 1 );
iz = min( iz, numel( obj.z ) - 1 );
%  bin coordinates
xx = ( x( : ) - obj.x( ix ) .' ) ./ ( obj.x( ix + 1 ) - obj.x( ix ) ) .';
yy = ( y( : ) - obj.y( iy ) .' ) ./ ( obj.y( iy + 1 ) - obj.y( iy ) ) .';
zz = ( z( : ) - obj.z( iz ) .' ) ./ ( obj.z( iz + 1 ) - obj.z( iz ) ) .';

%  size of interpolation array
siz = [ numel( obj.x ), numel( obj.y ), numel( obj.z ) ];
%  interpolation indices
ind = [ sub2ind( siz, ix + 0, iy + 0, iz + 0 ),  ...
        sub2ind( siz, ix + 1, iy + 0, iz + 0 ),  ...
        sub2ind( siz, ix + 0, iy + 1, iz + 0 ),  ...
        sub2ind( siz, ix + 1, iy + 1, iz + 0 ),  ...
        sub2ind( siz, ix + 0, iy + 0, iz + 1 ),  ...
        sub2ind( siz, ix + 1, iy + 0, iz + 1 ),  ...
        sub2ind( siz, ix + 0, iy + 1, iz + 1 ),  ...
        sub2ind( siz, ix + 1, iy + 1, iz + 1 ) ];
%  interpolation weights
w = [ ( 1 - xx ) .* ( 1 - yy ) .* ( 1 - zz ),  ...
            xx   .* ( 1 - yy ) .* ( 1 - zz ),  ...
      ( 1 - xx ) .*       yy   .* ( 1 - zz ),  ...
            xx   .*       yy   .* ( 1 - zz ),  ...
      ( 1 - xx ) .* ( 1 - yy ) .*       zz  ,  ...
            xx   .* ( 1 - yy ) .*       zz  ,  ...
      ( 1 - xx ) .*       yy   .*       zz  ,  ...
            xx   .*       yy   .*       zz ];

%  interpolation function for trilinear interpolation
fun = @( v ) reshape( sum( w .* v( ind ), 2 ), size( x ) );
