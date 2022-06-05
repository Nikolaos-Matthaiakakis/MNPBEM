function result = mtimes( first, second )
%  MTIMES - Multiplication of hierarchical and numerical matrices.
%
%  Usage for obj = hmatrix :
%    obj = val * obj
%    mat = obj * mat
%    obj = obj1 * obj2
%  Input
%    mat    :  full matrix
%    val    :  sparse diagonal

%  multiplication with scalar
if isscalar( first ) && isnumeric( first ) && isa( second, 'hmatrix' )
  %  set output
  result = second;
  %  multiply H-matrix with scalar
  result.val = cellfun( @( val ) first * val, result.val, 'uniform', 0 );
  result.lhs = cellfun( @( lhs ) first * lhs, result.lhs, 'uniform', 0 );
  
%  multiplication of H-matrix with sparse diagonal
elseif ( issparse( first  ) && isa( second, 'hmatrix' ) ) ||  ...
       ( issparse( second ) && isa( first,  'hmatrix' ) )
  result = mtimes1( first, second );
  
%  multiplication of H-matrix with matrix  
elseif isa( first, 'hmatrix' ) && isnumeric( second )
  result = mtimes2( first, second );
  
%  multiplication of two H-matrices  
elseif isa( first, 'hmatrix' ) && isa( second, 'hmatrix' )
  result = mtimes3( first, second );                 
end
