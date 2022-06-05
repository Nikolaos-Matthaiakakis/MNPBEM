function obj = plus( obj1, obj2 )
%  PLUS - Add hierarchical matrices.
%
%  Usage for obj = hmatrix :
%    obj = plus( obj1, obj2 )
%    obj = obj1 + obj2

if issparse( obj1 ) && isa( obj2, 'hmatrix' )
  %  add sparse matrix and H-matrix
  obj = plus1( obj2, obj1 );
elseif isa( obj1, 'hmatrix' ) && issparse( obj2 )
  obj = plus1( obj1, obj2 );
else
  %  add two H-matrices    
  obj = plus2( obj1, obj2 );  
end

%  clear statistics
obj.stat = [];
