function x = solve( obj, b, key )
%  SOLVE - Solve matrix equation (L*U)*x = b for LU hierarchical matrix.
%
%  Usage for obj = hmatrix :
%    x = solve( obj, b )
%    x = solve( obj, b, key )
%  Input
%    b      :  inhomogeneity
%    key   :  'L' for lower, 'U' for upper matrix, 'N' for both (default)
%  Output
%    x      :  solution vector

if ~exist( 'key', 'var' ),  key = 'N';  end
%  tree and change to cluster indexing
tree = treemex( obj );
b = part2cluster( obj.tree, b );
%  call MEX function
x = hmatsolve( tree, obj.val, obj.lhs, obj.rhs, b, key );
%  clear persistent variables and change back to particle ordering
clear hmatlu;
x = cluster2part( obj.tree, x );
