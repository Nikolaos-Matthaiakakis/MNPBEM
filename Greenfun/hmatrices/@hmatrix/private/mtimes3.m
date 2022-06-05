function obj1 = mtimes3( obj1, obj2 )
%  MTIMES - Multiplication of hierarchical matrices.
%
%  Usage for obj = hmatrix :
%    obj = mtimes3( obj1, obj2 )
%  Output
%    obj    :  matrix multiplication obj1 * obj2

%  tree to be passed to MEX function of HLIB
tree = treemex( obj1 );
op = struct( 'htol', obj1.htol, 'kmax', obj1.kmax );
%  multiplication of H-matrix with matrix
[ obj1.val, obj1.lhs, obj1.rhs, obj1.stat ] =  ...
    hmatmul2( tree, obj1.val, obj1.lhs, obj1.rhs,   ...
                    obj2.val, obj2.lhs, obj2.rhs, op );  
%  clear persistent variables
clear hmatmul2;                  
                  