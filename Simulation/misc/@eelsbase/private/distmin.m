function dmin = distmin( p, pos, cutoff )
%  DISTMIN - Minimum distace in 2D between particle faces and positions.
%  
%  Usage :
%    dmin = distmin( p, pos )
%  Input
%    p          :  particle object
%    pos        :  positions 
%    cutoff     :  consider only values smaller than given cutoff value
%  Output
%    dmin       :  minimum distance between particle faces and positions

%  number of positions
npos = size( pos, 1 );

%  face connections
[ net, inet ] = nettable( p.faces );
%  find unique edges
[ net, ~, i2 ] = unique( sort( net, 2 ), 'rows' );

%  net positions
xv = repmat( p.verts( net( :, 1 ), 1 ), 1, npos );
yv = repmat( p.verts( net( :, 1 ), 2 ), 1, npos );
%  net directions
dx = repmat( p.verts( net( :, 2 ), 1 ), 1, npos ) - xv;
dy = repmat( p.verts( net( :, 2 ), 2 ), 1, npos ) - yv;
%  particle positions
x = repmat( pos( :, 1 )', size( net, 1 ), 1 );
y = repmat( pos( :, 2 )', size( net, 1 ), 1 );

%  parameter to determine minimum distance along net lines
lambda = ( dx .* ( x - xv ) + dy .* ( y - yv ) ) ./  ...
                                 max( dx .^ 2 + dy .^ 2, eps );
%  lambda must be in range [ 0, 1 ]
lambda = min( max( lambda, 0 ), 1 );
%  minimum distance to connections
dnet = sqrt( ( x - xv - lambda .* dx ) .^ 2 +  ...
             ( y - yv - lambda .* dy ) .^ 2 );

%  allocate array
dmin = NaN( p.n, npos );
%  transform from unique connections to connections
dnet = dnet( i2, : );
%  minimum distance to faces
for i = 1 : npos
  ind = dnet( :, i ) < cutoff;
  dmin( :, i ) =  ...
    accumarray( inet( ind ), dnet( ind, i ), [ p.n, 1 ], @min, NaN );
end
