function mat = mtimes2( obj, mat )
%  MTIMES - Multiplication of hierarchical and numerical matrix.
%
%  Usage for obj = hmatrix :
%    mat = mtimes2( obj, mat );
%  Input
%    mat    :  numerical matrix
%  Output
%    mat    :  obj * mat

%  tree to be passed to MEX function of HLIB
tree = treemex( obj );
%  change to cluster index
mat = part2cluster( obj.tree, mat );
%  treat case that H-matrix is real and matrix complex
if ~isreal( mat ),  obj.val{ 1 } = complex( obj.val{ 1 } );  end
%  multiplication of H-matrix with matrix
mat = hmatmul1( tree, obj.val, obj.lhs, obj.rhs, mat );
mat = cluster2part( obj.tree, mat );
%  clear persistent variables
clear hmatmul1;
  