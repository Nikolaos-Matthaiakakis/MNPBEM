function result = mtimes1( first, second )
%  MTIMES - Multiplication of hierarchical and sparse diagonal.
%
%  Usage for obj = hmatrix :
%    obj = mtimes1( obj, mat )
%    obj = mtimes1( mat, obj )
%  Input
%    mat    :  sparse diagonal

%  mat * obj
if issparse( first )
  %  set output
  result = second;
  %  values of sparse diagonal, change to cluster indexing
  d = full( diag( first ) );
  d = reshape( part2cluster( second.tree, d ), [], 1 );
  %  cluster indices
  ind1 = reshape( num2cell( second.tree.cind( second.row1, : ), 2 ), size( second.val ) );
  ind2 = reshape( num2cell( second.tree.cind( second.row2, : ), 2 ), size( second.lhs ) );
  %  multiply H-matrix
  result.val = cellfun( @( val, ind )  ...
    bsxfun( @times, val, d( ind( 1 ) : ind( 2 ) ) ), second.val, ind1, 'uniform', 0 );
  result.lhs = cellfun( @( lhs, ind )  ...
    bsxfun( @times, lhs, d( ind( 1 ) : ind( 2 ) ) ), second.lhs, ind2, 'uniform', 0 );
  
%  obj * mat  
else
  %  set output
  result = first;
  %  values of sparse diagonal, change to cluster indexing
  d = full( diag( second ) );
  d = reshape( part2cluster( first.tree, d ), [], 1 );
  %  cluster indices
  ind1 = reshape( num2cell( first.tree.cind( first.col1, : ), 2 ), size( first.val ) );
  ind2 = reshape( num2cell( first.tree.cind( first.col2, : ), 2 ), size( first.rhs ) );
  %  multiply H-matrix
  result.val = cellfun( @( val, ind )  ...
    bsxfun( @times, val, d( ind( 1 ) : ind( 2 ) ) .' ), first.val, ind1, 'uniform', 0 );
  result.rhs = cellfun( @( rhs, ind )  ...
    bsxfun( @times, rhs, d( ind( 1 ) : ind( 2 ) )    ), first.rhs, ind2, 'uniform', 0 );  
end

%  clear statistics
result.stat = [];
