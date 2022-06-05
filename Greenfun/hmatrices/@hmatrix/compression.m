function eta = compression( obj )
%  COMPRESSION - Degree of compression for H-matrix.
%
%  Usage for obj = hmatrix :
%    eta = compression( obj )
%  Output
%    eta    :  ration between elements of H-matrix and full matrix

%  number of H-matrix elements
n = sum( cellfun( @( val ) numel( val ), obj.val, 'uniform', 1 ) ) +  ...
    sum( cellfun( @( lhs, rhs ) numel( lhs ) + numel( rhs ), obj.lhs, obj.rhs, 'uniform', 1 ) ); 
%  degree of compression
eta = n / prod( matsize( obj.tree, obj.tree ) );
