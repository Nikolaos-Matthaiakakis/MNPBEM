function obj = init( obj, p, pos1, varargin )
%  INIT - Initialize compoint.

%  make sure that P is a COMPARTICLE
assert( isa( p, 'comparticle' ) );
%  save P and total number of positions
[ obj.pin, obj.npos ] = deal( p, size( pos1, 1 ) );

%  extract input
op = getbemoptions( varargin{ : } );
%  default value for minimum distance to nearest neighbour
if ~isfield( op, 'mindist' )
  mindist = zeros( p.np, 1 );  
else
  mindist = op.mindist;
end
%  treat case where mindist is a single value
if length( mindist ) ~= p.np;   mindist = repmat( mindist, p.np, 1 );  end
  
%  minimal distance between particle and positions
[ r, ind2 ] = distmin3( p, pos1, max( mindist ) );
%  conversion table between face indices and particle number
ind2part = zeros( p.n, 1 );

for ip = 1 : p.np
  ind2part( p.index( ip ) ) = ip;
end

%  keep only positions sufficiently far away from boundaries
ind1 = find( abs( r ) >= mindist( ind2part( ind2 ) ) );
r = r( ind1 );

%  determine wether point is in- or out-side the nearest surface
inout = zeros( length( ind1 ), 1 );
%  depending on sig, pos1 is in- or out-side the nearest surface                                  
inout( r <  0 ) = p.inout( ind2part( ind2( ind1( r <  0 ) ) ), 1 );
inout( r >= 0 ) = p.inout( ind2part( ind2( ind1( r >= 0 ) ) ), 2 );

if isfield( op, 'layer' )
  %  save layer structure
  obj.layer = op.layer;
  %  index to points connected to layer structure
  indl = any( bsxfun( @eq, inout, reshape( op.layer.ind, 1, [] ) ), 2 );
  %  index to positions
  indl1 = ind1( indl );
  %  points in layer
  in = op.layer.mindist( pos1( indl1, 3 ) ) < 1e-10;
  %  move points into upper layer
  pos1( indl1( in ), 3 ) = pos1( indl1( in ), 3 ) + 1e-8;
  %  assign substrate index to INOUT
  inout( indl ) = op.layer.ind( indlayer( op.layer, pos1( indl1, 3 ) ) );
end

%  group together points
iotab = unique( inout );

%  loop over different media
for i = 1 : length( iotab )
  %  pointer to set of points in given medium
  obj.ind{ i } = ind1( inout == iotab( i ) );
  %  set of points in given medium
  obj.p{ i } = point( pos1( obj.ind{ i }, : ) );
  %  pointer to dielectric function 
  obj.inout( i, 1 ) = iotab( i );
end

%  mask points
if ~isfield( op, 'medium' )
  obj.mask = 1 : length( obj.inout );
else
  for i = 1 : length( iotab )
    if any( op.medium == iotab( i ) )
      obj.mask = [ obj.mask, i ];
    end
  end
end

%  compound of points
obj.pc = vertcat( obj.p{ obj.mask } );
