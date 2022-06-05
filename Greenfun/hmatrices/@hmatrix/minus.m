function obj1 = minus( obj1, obj2 )
%  MINUS - Subtract hierarchical matrices.
%
%  Usage for obj = hmatrix :
%    obj = minus( obj1, obj2 )
%    obj = obj1 - obj2

%  subtract matrices
obj1 = plus( obj1, -obj2 );
