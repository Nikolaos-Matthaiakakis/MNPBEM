function obj = aca( obj, fun )
%  ACA - Fill matrix with user-defined function using ACA.
%
%  Usage for obj = hmatrix :
%    obj = aca( obj, fun )
%  Input
%    fun    :  user-defined function fun( row, col ) that returns matrix
%              values for given rows and columns, e.g. for full matrix A
%              fun = @(row,col) A(sub2ind([n,n],row,col));
%  Output
%    obj    :  H-matrix with full and low-rank matrices
%
%  Warning - This function is only for testing or for small matrices.  For
%  large matrices ACA can be very slow and we recommend writing a MEX file
%  which uses a C++ class derived from the acafunc class (see aca.h).

tree = obj.tree;
%  transformation to cluster indices
ind = tree.ind( :, 2 );
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

%  parameters for MEX function
tree = treemex( obj );
zflag = logical( ~isreal( fun2( 1, 1 ) ) );
op = struct( 'htol', min( obj.htol ), 'kmax', max( obj.kmax ) );
%  compute low-rank matrices
[ obj.lhs, obj.rhs ] =  ...
  hmatfun( tree, fun2, zflag, uintmex( 0 ), uintmex( 0 ), op );
