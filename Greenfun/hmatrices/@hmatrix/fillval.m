function obj = fillval( obj, fun )
%  FILLVAL - Fill matrix with user-defined function using ACA.
%
%  Usage for obj = hmatrix :
%    obj = fillval( obj, fun )
%  Input
%    fun    :  user-defined function fun( row, col ) that returns matrix
%              values for given rows and columns, e.g. for full matrix A
%              fun = @(row,col) A(sub2ind([n,n],row,col));
%  Output
%    obj    :  H-matrix with full matrices

tree = obj.tree;
%  transformation to cluster indices
ind = tree.ind( :, 1 );
%  modify input function
fun2 = @( row, col ) fun( ind( row ), ind( col ) );

%  compute full matrices
for i = 1 : numel( obj.row1 )
  %  cluster indices
  indr = tree.cind( obj.row1( i ), : );
  indc = tree.cind( obj.col1( i ), : );
  %  rows and columns
  [ row, col ] = ndgrid( indr( 1 ) : indr( 2 ), indc( 1 ) : indc( 2 ) );
  %  get function values
  obj.val{ i } = reshape( fun2( row( : ), col( : ) ), size( row ) );
end
