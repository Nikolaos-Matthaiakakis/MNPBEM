function v = part2cluster( obj, v )
%  PART2CLUSTER - Conversion from particle index to cluster index.
%
%  Usage for obj = clustertree :
%    v = part2cluster( obj, v )
%  Input
%    v      :  matrix with particle index
%  Output
%    v      :  matrix with cluster index

v = reshape( v( obj.ind( :, 1 ), : ), size( v ) );
