function obj = scale( obj, scale )
%  SCALE - Scale polygon.
%
%  Usage for obj = polygon :
%    obj = scale( obj, scale )
%    obj = scale( obj, [ scale( 1 ), scale( 2 ) ] )
%  Input
%    scale  :  scaling factor

if length( scale ) == 1
  scale = repmat( scale, [ 1, 2 ] );
end
%  loop over particles
for i = 1 : numel( obj )
  obj( i ).pos = bsxfun( @times, obj( i ).pos, scale );
end
