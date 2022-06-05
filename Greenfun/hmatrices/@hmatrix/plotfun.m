function plotfun( obj, mat, fun )
%  PLOTFUN - Plot function applied hierarchical matrix.
%
%  Usage for obj = hmatrix :
%    plotfun( obj, mat, fun )
%  Input
%    mat    :  additonal matrix, [] if none provided
%    fun    :  plot function @(x,y), where x is the hierarchical matrix and
%              y the corresponding sub-matrix of MAT, e.g.
%              @( x, y ) norm( x - y ) / norm( y )

%  allocate array
fmat = zeros( matsize( obj.tree1, obj.tree2 ) );
%  cluster indices
[ cind1, cind2 ] = deal( obj.tree1.cind, obj.tree2.cind );
%  sub-matrix
sub = [];

%  loop over full matrices
for i = 1 : numel( obj.row1 )
  %  cluster indices
  row = cind1( obj.row1( i ), 1 ) : cind2( obj.row1( i ), 2 );
  col = cind2( obj.col1( i ), 1 ) : cind2( obj.col1( i ), 2 );
  %  sub-matrix
  if ~isempty( mat )
    sub = mat( obj.tree1.ind( row ), obj.tree2.ind( col ) );
  end
  %  call user-defined function
  fmat( row, col ) = fun( obj.val{ i }, sub );
end

%  loop over low-rank matrices
for i = 1 : numel( obj.row2 )
  %  cluster indices
  row = cind1( obj.row2( i ), 1 ) : cind2( obj.row2( i ), 2 );
  col = cind2( obj.col2( i ), 1 ) : cind2( obj.col2( i ), 2 );
  %  sub-matrix
  if ~isempty( mat )
    sub = mat( obj.tree1.ind( row ), obj.tree2.ind( col ) );
  end
  %  call user-defined function
  fmat( row, col ) = fun( obj.lhs{ i } * obj.rhs{ i }', sub );
end

%  plot matrix
imagesc( fmat );  hold on;

%  box coordinates for cluster
[ x, y ] = arrayfun( @( i1, i2 )  ...
  box( cind1, cind2, i1, i2 ), obj.row2, obj.col2, 'uniform', 0 );  
%  plot cluster boundaries
plot( cell2mat( transpose( x ) ), cell2mat( transpose( y ) ), 'k-' );


function [ x, y ] = box( cind1, cind2, i1, i2 )
%  BOX - Box coordinates for cluster.

%  cluster indices
cind1 = cind1( i1, : ) + 0.5 * [ -1, 1 ];
cind2 = cind2( i2, : ) + 0.5 * [ -1, 1 ];  
%  box coordinates
x = [ cind2( 1 ), cind2( 2 ), cind2( 2 ), cind2( 1 ), nan ];
y = [ cind1( 1 ), cind1( 1 ), cind1( 2 ), cind1( 2 ), nan ];


