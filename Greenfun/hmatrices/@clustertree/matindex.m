function [ ind, siz, n ] = matindex( obj1, obj2, i1, i2 )
%  MATINDEX - Index for cluster tree sub.matrix.
%
%  Usage for obj = clustertree :
%    [ ind, siz, n ] = matindex( obj1, obj2, i1, i2 )
%  Input
%    i1     :  index for cluster tree 1
%    i2     :  index for cluster tree 2
%  Output
%    ind    :  linear index 
%    siz    :  size of cluster sub-matrix
%    n      :  number of sub-matrix elements
%
%  Given a matrix MAT with particle indices, MAT(IND) returns the elements
%  of the sub-matrix for cluster (I1,I2).

%  cluster indices
[ row, col ] = ndgrid( obj1.ind( obj1.cind( i1, 1 ) : obj1.cind( i1, 2 ) ),  ...
                       obj2.ind( obj2.cind( i2, 1 ) : obj2.cind( i2, 2 ) ) );
%  matrix index
ind = sub2ind( matsize( obj1, obj2 ), row( : ), col( : ) );
%  size of sub-matrix and number of matrix elements
[ siz, n ] = deal( size( row ), numel( row ) );
