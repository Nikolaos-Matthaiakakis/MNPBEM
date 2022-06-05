function obj1 = plus2( obj1, obj2 )
%  PLUS2 - Add hierarchical matrices.
%
%  Usage for obj = hmatrix :
%    obj = plus2( obj1, obj2 )

%  tree and options to be passed to MEX function of HLIB
tree = treemex( obj1 );
op = struct( 'htol', obj1.htol, 'kmax', obj1.kmax );
%  call MEX function
[ obj1.val, obj1.lhs, obj1.rhs ] =  ...
  hmatadd( tree, obj1.val, obj1.lhs, obj1.rhs, obj2.val, obj2.lhs, obj2.rhs, op );
%  clear persistent variables
clear hmatadd;
