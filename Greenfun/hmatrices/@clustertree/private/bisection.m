function tree = bisection( p, tree, ic, ind, cind, cleaf )
%  BISECTION - Construction of cluster tree by bisection.
%
%  Boerm et al., Eng. Analysis with Bound. Elem. 27, 405 (2003), Example 2.1

%  size of tree
siz = numel( tree );
%  add sons to parent node
tree{ ic }.son1 = siz + 1;
tree{ ic }.son2 = siz + 2;
%  split cluster
[ tree{ siz + 1 }, tree{ siz + 2 },  ...
                 ind1, ind2, cind1, cind2, psplit ] = split( p, ind, cind );

%  further splitting of cluster 1 ?
if numel( ind1 ) > cleaf || psplit
  tree = bisection( p, tree, siz + 1, ind1, cind1, cleaf );
else
  tree{ siz + 1 }.ind = ind1;
end
%  further splitting of cluster 2 ?
if numel( ind2 ) > cleaf || psplit
  tree = bisection( p, tree, siz + 2, ind2, cind2, cleaf );
else
  tree{ siz + 2 }.ind = ind2;
end


function box = boundary( p, ind )
%  BOUNDARY - Boundary box for cluster.

posmin = min( p.pos( ind, : ), [], 1 );
posmax = max( p.pos( ind, : ), [], 1 );
%  boundary box
box = [ posmin; posmax ];


function box = sphboundary( p, ind )
%  SPHBOUNDARY - Sphere boundary for cluster

box = boundary( p, ind );
%  center position and radius
box = struct( 'mid', mean( box, 1 ),  ...
              'rad', 0.5 * norm( box( 2, : ) - box( 1, : ) ) );


function [ ind1, ind2 ] = bisplit( p, ind )
%  BISPLIT - Split cluster by bisection.

%  bounding box
box = boundary( p, ind );
%  split direction 
[ ~, k ] = max( box( 2, : ) - box( 1, : ) );
%  split position
mid = box( 1, k ) + 0.5 * ( box( 2, k ) - box( 1, k ) );

%  split cluster
ind1 = ind( p.pos( ind, k ) <  mid );
ind2 = setdiff( ind, ind1 );


function [ ind1, ind2 ] = partsplit( p, ind )
%  PARTSPLIT - Split cluster into different particle boundaries.

%  particle index
ip = ipart( p, ind );

if numel( unique( ip ) ) == 1
  [ ind1, ind2 ] = deal( [] );
else
  ind1 = ind( ip == ip( 1 ) );
  ind2 = setdiff( ind, ind1 );
end


function [ son1, son2, ind1, ind2, cind1, cind2, psplit ] = split( p, ind, cind )
%  SPLIT - Split cluster.
%
%  Input
%    ind   :  face index
%    cind  :  cluster index

%  try particle split
[ ind1, ind2 ] = partsplit( p, ind );
psplit = ~isempty( ind1 );
%  bisection split ?
if isempty( ind1 )
  [ ind1, ind2 ] = bisplit( p, ind );
end
%  cluster index
cind1 = cind( 1 : numel( ind1 ) );
cind2 = setdiff( cind, cind1 );

%  sons
son1 = struct( 'cind', [ cind1( 1 ), cind1( end ) ], 'box', sphboundary( p, ind1 ) );
son2 = struct( 'cind', [ cind2( 1 ), cind2( end ) ], 'box', sphboundary( p, ind2 ) );
  