function obj = eye( obj )
%  EYE - Hierarchical unit matrix.
%
%  Usage for obj = hmatrix :
%    obj = eye( obj )
%  Output
%    obj    :  unit H-matrix

%  rows and columns of full matrices
[ row1, col1 ] = deal( obj.row1, obj.col1 );
%  index for diagonal matrices
ind = row1 == col1;

%  clear full matrices
obj.val = cell( numel( row1 ), 1 );
%  clear low-rank matrices
[ obj.lhs, obj.rhs ] = deal( cell( numel( obj.row2 ), 1 ) );

%  pad with zeros
obj = pad( obj );
%  set diagonal matrices
obj.val( ind ) = cellfun( @( x ) eye( size( x ) ), obj.val( ind ), 'uniform', 0 );
