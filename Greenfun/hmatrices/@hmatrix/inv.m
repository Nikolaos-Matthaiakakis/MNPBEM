function obj = inv( obj )
%  INV - Inverse of hierarchical matrix.
%
%  Usage for obj = hmatrix :
%    obj = inv( obj )
%  Output
%    obj    :  inverse of H-matrix

%  tree and options to be passed to MEX function of HLIB
tree = treemex( obj );
op = struct( 'htol', obj.htol, 'kmax', obj.kmax );
%  call MEX function
[ obj.val, obj.lhs, obj.rhs, obj.stat ] = hmatinv( tree, obj.val, obj.lhs, obj.rhs, op );
%  clear persistent variables
clear hmatinv;
