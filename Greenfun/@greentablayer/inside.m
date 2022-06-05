function in = inside( obj, r, z1, z2 )
%  INSIDE - Determine whether coordinates are inside of tabulated range.
%
%  Usage for obj = greentablayer :
%    in = inside( obj, r, z1, z2 )
%    in = inside( obj, r, z1     )
%  Input
%    r          :  radii
%    z1, z2     :  z-values
%  Output
%    in         :  1 if inside of tabulated region and 0 otherwise

layer = obj.layer;
%  round radii and z-values
r = max( layer.rmin, r );  [ z1, z2 ] = round( layer, z1, z2 );
%  inside function
fun = @( x, limits ) x >= min( limits ) & x <= max( limits );

%  uppermost or lowermost layer
if numel( obj.z2 ) == 1
  %  index to layers
  ind1 = indlayer( layer, z1 );  
  ind2 = indlayer( layer, z2 );  
  %  find z-values in uppermost or lowermost layer
  in1 = ( ind1 == ind2 ) & ( ind1 == 1               );
  in2 = ( ind1 == ind2 ) & ( ind1 == obj.layer.n + 1 );  
  in = in1 | in2;
  %  determine whether inside
  in( in1 ) = fun( r( in1 ), obj.r ) & fun( z1( in1 ) + mindist( layer, z2( in1 ) ), obj.z1 );
  in( in2 ) = fun( r( in2 ), obj.r ) & fun( z1( in2 ) - mindist( layer, z2( in2 ) ), obj.z1 );
else
  in = fun( r, obj.r ) & fun( z1, obj.z1 ) & fun( z2, obj.z2 );
end

