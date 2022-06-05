function [ lhs, rhs ] = lowrank1( obj, i, j, key, enei )
%  LOWRANK1 - Evaluate low-rank matrices for layer structure (direct).
%
%  Usage for obj = aca.compgreenretlayer :
%    [ lhs, rhs ] = lowrank1( obj, i, j, key, enei )
%  Input
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%    enei   :  light wavelength in vacuum
%  Output
%    lhs    :   left-hand side of low-rank matrix
%    rhs    :  right-hand side of low-rank matrix

[ p, hmat ] = deal( obj.p, obj.hmat );
%  size of clusters
tree = hmat.tree;
siz = tree.cind( :, 2 ) - tree.cind( :, 1 ) + 1;
%  allocate low-rank matrices
lhs = arrayfun( @( x ) zeros( x, 1 ), siz( hmat.row2 ), 'uniform', 0 );
rhs = arrayfun( @( x ) zeros( x, 1 ), siz( hmat.col2 ), 'uniform', 0 );

%  connectivity matrix
con = obj.g.g.con{ i, j };
%  evaluate dielectric functions to get wavenumbers
[ ~, k ] = cellfun( @( eps ) ( eps( enei ) ), obj.p.eps, 'uniform', 1 );
%  place wavevectors into cell array
con( con == 0 ) = nan;  con( ~isnan( con ) ) = k( con( ~isnan( con ) ) );

%  particle structure for MEX function call
ind = hmat.tree.ind( :, 1 );
pmex = struct( 'pos', p.pos( ind, : ), 'nvec', p.nvec( ind, : ), 'area', p.area( ind ) );
%  tree indices and options for MEX function call
tmex = treemex( hmat );
op = struct( 'htol', hmat.htol, 'kmax', hmat.kmax );

for i = 1 : size( con, 1 )
for j = 1 : size( con, 2 )
  if ~isnan( con( i, j ) )
    %  starting cluster
    row = uintmex( obj.ind( i ) - 1 );
    col = uintmex( obj.ind( j ) - 1 );
    %  compute low-rank matrix using ACA
    switch key
      case 'G'
        [ L, R ] = hmatgreenret( pmex, tmex, 'G', row, col, complex( con( i, j ) ), op );  
      case { 'F', 'H1', 'H2' }
        [ L, R ] = hmatgreenret( pmex, tmex, 'F', row, col, complex( con( i, j ) ), op );
    end    
    %  index to low-rank matrices
    ind = cellfun( @( x ) ~isempty( x ), L, 'uniform', 1 );
    %  set low-rank matrices
    lhs( ind ) = L( ind );
    rhs( ind ) = R( ind );
  end
end
end
