function obj = uminus( obj )
%  UMINUS - Unary minus for hierarchical matrix.
%
%  Usage for obj = hmatrix :
%    obj = uminus( obj )
%  Output
%    obj    :  negative of input matrix

obj.val = cellfun( @( val ) - val, obj.val, 'uniform', 0 );
obj.lhs = cellfun( @( lhs ) - lhs, obj.lhs, 'uniform', 0 );
