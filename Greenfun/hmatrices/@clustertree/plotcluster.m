function plotcluster( obj, key )
%  PLOTCLUSTER - Plot clusters of cluster tree.
%
%  Usage for obj = clustertree :
%    plotcluster( obj )
%    plotcluster( obj, key )
%  Input
%    key    :  'parent'  -  plot clusters and parents
%              'single'  -  plot clusters only
%  Output
%    cluster plot

if ~exist( 'key', 'var' ),  key = 'single';  end

%  allocate array
cluster = zeros( obj.p.n, size( obj.son, 1 ) );
%  fill clusters
cluster = fun( obj, cluster, 1 );

%  single clusters or clusters and parents ?
switch key
  case 'single'
    for ind = 1 : size( cluster, 2 )
      cluster( :, ind ) = cluster( :, ind ) == max( cluster( :, ind ) );
    end
  case 'parent'
    for ind = 1 : size( cluster, 2 )
      [ ~, ~, cluster( :, ind ) ] = unique( cluster( :, ind ) );
    end
    cluster = cluster - 1;
end

%  plot cluster
plot( obj.p, cluster2part( obj, cluster ) );


function cluster = fun( obj, cluster, ind )
%  FUN - Fill clusters.

%  cluster indices
cind = obj.cind( ind, 1 ) : obj.cind( ind, 2 );
%  fill cluster
cluster( cind, ind ) = ind;

%  deal with sons
if ~all( obj.son( ind, : ) == 0 )
  %  sons
  [ ind1, ind2 ] = deal( obj.son( ind, 1 ), obj.son( ind, 2 ) );
  %  fill sons of cluster
  cluster( :, ind1 ) = cluster( :, ind );  cluster = fun( obj, cluster, ind1 );
  cluster( :, ind2 ) = cluster( :, ind );  cluster = fun( obj, cluster, ind2 );
end