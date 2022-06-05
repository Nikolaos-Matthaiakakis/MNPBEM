function v = cluster2part( obj, v )
%  CLUSTER2PART - Conversion from cluster index to particle index.
%
%  Usage for obj = clustertree :
%    v = cluster2part( obj, v )
%  Input
%    v      :  matrix with cluster index
%  Output
%    v      :  matrix with particle index

v = reshape( v( obj.ind( :, 2 ), : ), size( v ) );
