function obj = plus1( obj, mat )
%  PLUS1 - Add hierarchical matrix and sparse matrix.
%
%  Usage for obj = hmatrix :
%    obj = plus1( obj, mat )

%  values of sparse diagonal
d = full( diag( mat ) );
d = reshape( part2cluster( obj.tree, d ), [], 1 );

%  cluster indices for full matrices
ind1 = reshape( num2cell( obj.tree.cind( obj.row1, : ), 2 ), size( obj.val ) );
%  diagonal clusters
ind = obj.row1 == obj.col1;
%  add sparse matrix to H-matrix
obj.val( ind ) = cellfun(  ...
  @( val, ind1 ) val + diag( d( ind1( 1 ) : ind1( 2 ) ) ),  ...
                          obj.val( ind ), ind1( ind ), 'uniform', 0 );
                        