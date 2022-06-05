function obj = pad( obj )
%  PAD - Pad missing submatrices of H-matrix with zeros.
%
%  Usage for obj = hmatrix :
%    obj = pad( obj )

tree = obj.tree;
%  size of clusters
siz = tree.cind( :, 2 ) - tree.cind( :, 1 ) + 1;
%  index to missing matrices
ind1 = cellfun( @( val ) isempty( val ), obj.val, 'uniform', 1 );
ind2 = cellfun( @( lhs ) isempty( lhs ), obj.lhs, 'uniform', 1 );

%  pad with zeros
obj.val( ind1 ) = arrayfun( @( m, n ) zeros( m, n ),  ...
  siz( obj.row1( ind1 ) ), siz( obj.col1( ind1 ) ), 'uniform', 0 );

obj.lhs( ind2 ) = arrayfun( @( m ) zeros( m, 1 ), siz( obj.row2( ind2 ) ), 'uniform', 0 );
obj.rhs( ind2 ) = arrayfun( @( m ) zeros( m, 1 ), siz( obj.col2( ind2 ) ), 'uniform', 0 );
  