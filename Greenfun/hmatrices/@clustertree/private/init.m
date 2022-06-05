function obj = init( obj, p, varargin )
%  INIT - Build cluster tree through bisection.
%
%  Usage for obj = clustertree :
%    obj = init( obj, p, op, PropertyPairs )
%    obj = init( obj, p,     PropertyPairs )
%  Input
%    p        :  particle faces and vertices
%  PropertyName
%    cleaf    :  threshold parameter for bisection
%
%  See S. Boerm et al., Eng. Analysis with Bound. Elem. 27, 405 (2003).

%  extract input
op = getbemoptions( { 'iter', 'hoptions' }, varargin{ : } );
%  get values
if isfield( op, 'cleaf' )
  cleaf = op.cleaf;
else
  cleaf = 32;
end
%  save particle
obj.p = p;

%%  set up tree
%    index to particle positions and cluster index
[ ind, cind ] = deal( 1 : p.n );

%  bounding box for particle
box = [ min( p.pos, [], 1 ); max( p.pos, [], 1 ) ];
%  center position and radius
box = struct( 'mid', mean( box, 1 ),  ...
              'rad', 0.5 * norm( box( 2, : ) - box( 1, : ) ) );

%  empty tree
tree = { struct( 'cind', [ 1, p.n ], 'box', box ) };
%  split tree by bisection
tree = bisection( p, tree, 1, ind, cind, cleaf );

%%  extract information from tree
obj.son = zeros( numel( tree ), 2 );
%  sons of tree
for i = 1 : numel( tree )
  if isfield( tree{ i }, 'son1' )
    obj.son( i, : ) = [ tree{ i }.son1, tree{ i }.son2 ];
  end
end

%  cluster index
obj.cind = cellfun( @( tree ) tree.cind, tree, 'uniform', 0 );
obj.cind = cell2mat( obj.cind( : ) );
%  extract bounding boxes
mid = cellfun( @( cluster ) cluster.box.mid, tree, 'uniform', 0 );
rad = cellfun( @( cluster ) cluster.box.rad, tree, 'uniform', 0 );
%  save bounding box
obj.mid = cell2mat( mid( : ) );
obj.rad = cell2mat( rad( : ) );

%% conversion between particle index and cluster index.
%  find leaves of tree
leaf = cellfun( @( cluster ) isfield( cluster, 'ind' ), tree );
%  index
 ind = cellfun( @( cluster ) cluster.ind, tree( leaf ), 'uniform', 0 );
%  cluster index
cind = cellfun( @( cluster ) cluster.cind( 1 ) : cluster.cind( 2 ),  ...
                                          tree( leaf ), 'uniform', 0 );
                                       
%  convert to array
 ind = cell2mat(  ind );  [ ~, i1 ] = sort(  ind );
cind = cell2mat( cind );  [ ~, i2 ] = sort( cind );
%  conversion 
obj.ind = [ reshape( ind( i2 ), [], 1 ), reshape( cind( i1 ), [], 1 ) ];

%%  particle index
ip1 = ipart( p, obj.ind( obj.cind( :, 1 ), 1 ) .' ) .';
ip2 = ipart( p, obj.ind( obj.cind( :, 2 ), 1 ) .' ) .';
%  zero for composite particles
ip1( ip1 ~= ip2 ) = 0;
%  save particle index
obj.ipart = ip1;
