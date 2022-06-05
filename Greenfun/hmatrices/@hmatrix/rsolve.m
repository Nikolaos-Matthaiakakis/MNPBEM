function obj1 = rsolve( obj1, obj2, key )
%  RSOLVE - Solve matrix equation X*(L*U) = B for LU hierarchical matrix.
%
%  Usage for obj = hmatrix :
%    obj = rsolve( obj1, obj2 )
%    obj = rsolve( obj1, obj2, key )
%  Input
%    obj1   :  B
%    obj2   :  (L*U)
%    key   :  'L' for lower, 'U' for upper matrix, 'N' for both (default)
%  Output
%    obj    :  X

if ~exist( 'key', 'var' ),  key = 'N';  end
%  tree and options to be passed to MEX function of HLIB
tree = treemex( obj1 );
op = struct( 'htol', obj1.htol, 'kmax', obj1.kmax );
%  call MEX function
[ obj1.val, obj1.lhs, obj1.rhs, obj1.stat ] =  ...
    hmatrsolve( tree, obj1.val, obj1.lhs, obj1.rhs, obj2.val, obj2.lhs, obj2.rhs, key, op );
%  clear persistent variables
clear hmatrsolve;
