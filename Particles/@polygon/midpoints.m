function obj = midpoints( obj, key )
%  MIDPOINTS - Add midpoints for odd polygon positions.
%
%  Usage :
%    obj = midpoints( obj )
%    obj = midpoints( obj, 'same' )
%  Input
%    poly   :  initial polygon
%    'same' :  positions of polygon already include midpoints, smooth only
%  Output
%    poly   :  smoothened polygon with midpoint positions

%  loop over different polygons
for i = 1 : length( obj )

  %  polygon positions
  if exist( 'key', 'var' ) && strcmp( key, 'same' )
    pos = [ obj( i ).pos( 1 : 2 : end, : ); obj( i ).pos( 1, : ) ];
  else
    pos = [ obj( i ).pos; obj( i ).pos( 1, : ) ];
  end  
  %  number of polygon positions
  n = size( pos, 1 ) - 1;  

  %  length of polygon pieces
  len = sqrt( sum( ( pos( 2 : end, : ) - pos( 1 : end - 1, : ) ) .^ 2, 2 ) );
  
  %  arc length of polygon
  x = [ 0; cumsum( len ) ];
  %  interpolation at halfways
  xi = 0.5 * ( x( 1 : end - 1 ) + x( 2 : end ) );
  
  %  interpolate positions
  posi = [ spline( x, pos( :, 1 ), xi ), spline( x, pos( :, 2 ), xi ) ];
  %  allocate array
  obj( i ).pos = zeros( 2 * n, 2 );
  %  set polygon positions
  obj( i ).pos( 1 : 2 : 2 * n, : ) = pos( 1 : end - 1, : );
  obj( i ).pos( 2 : 2 : 2 * n, : ) = posi;  
end
