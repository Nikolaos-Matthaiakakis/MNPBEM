function [ obj, distp ] = shiftbnd( obj, dist )
%  SHIFTBND - Shift boundary of polygon along normal directions.
%
%  Usage for obj = polygon
%    [ obj, dist ] = shiftbnd( obj, dist )
%  Input
%    obj    :  single object or array
%    dist   :  shift polygon vertices along normal directions by dist
%  Output
%    obj    :  shifted polygon
%    distp  :  actually displacement values for each polygon

if length( obj ) ~= 1
  distp = [];
  for i = 1 : length( obj )
    obj( i ) = shiftbnd( obj( i ), dist );
  end
else
  %  When displacing the nodes along straight lines which point into the
  %  directions of the normal vectors, we have to be careful that the
  %  crossing points are not located *before* the displaced points.
  
  %  positions
  [ x, y ] = deal( obj.pos( :, 1 ), obj.pos( :, 2 ) );
  %  displacement vectors
  nvec = sign( dist ) * norm( obj );
  [ nx, ny ] = deal( nvec( :, 1 ), nvec( :, 2 ) );
  
  %  inner product of displacement vector and normal vector
  in = nx * ny' - ny * nx'; 
  in( abs( in ) < 1e-10 ) = 0;
  %  distance to crossing points of lines
  lambda = ( repmat( ( x .* ny  - y .* nx  )', length( x ), 1 ) -  ...
                     ( x  * ny' - y  * nx' ) ) ./ in;
                   
  %  discard points on diagonal, negative displacements, and points that
  %  would not cross
  lambda( isnan( lambda ) | lambda < 0 | ( lambda .* lambda' ) < 0 ) = 1e10;
  %  in case of crossing, take the larger value
  a = max( lambda, lambda' );
  lambda( lambda ~= 1e10 ) = a( lambda ~= 1e10 );
  %  determine how far vertices should be displaced
  lambda = min( 0.8 * lambda, [], 2 );
  lambda( lambda > abs( dist ) ) = abs( dist );
  
  %  displace vertices
  obj.pos = obj.pos + [ lambda .* nx, lambda .* ny ];
  %  displacement value
  distp = sign( dist ) * lambda;
end
