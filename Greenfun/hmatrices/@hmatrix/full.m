function mat = full( obj )
%  FULL - Compute full matrix from hierarchical matrix.
%
%  Usage for obj = hmatrix :
%    mat = full( obj )
%  Output
%    mat  :  full matrix

%  tree to be passed to MEX function of HLIB
tree = treemex( obj );
%  call MEX function
mat = hmatfull( tree, obj.val, obj.lhs, obj.rhs );
%  clear persistent variables
clear hmatfull;

%  transform to particle indices
ind = obj.tree.ind( :, 2 );
%  change from cluster index to normal index
mat = mat( ind, ind );
