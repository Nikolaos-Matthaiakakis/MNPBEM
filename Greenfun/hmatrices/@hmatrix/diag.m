function d = diag( obj )
%  DIAG - Diagonal of hierarchical matrix.
%
%  Usage for obj = hmatrix :
%    d = diag( obj )
%  Output
%    d    :  diagonal of hierarchical matrix

%  tree
tree = obj.tree;
%  allocate output
d = zeros( size( tree.ind, 1 ), 1 );

%  find matrices on diagonal
id = find( obj.row1 == obj.col1 );
%  loop over sub-matrices
for i = reshape( id, 1, [] )
  %  index 
  ind = tree.cind( obj.row1( i ), 1 ) : tree.cind( obj.col1( i ), 2 );
  %  add to diagonal
  d( ind ) = diag( obj.val{ i } );
end
  
%  convert to particle indices
d = d( tree.ind( :, 2 ) );
