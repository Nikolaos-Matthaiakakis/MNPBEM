function hmat = eval( obj, i, j, key, enei )
%  EVAL - Evaluate retarded Green function.
%
%  Deals with calls to obj = aca.compgreenret :
%    g = obj{ i, j }.G( enei )
%
%  Usage for obj = aca.compgreenret :
%    g = eval( obj, i, j, key, enei )
%  Input
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%    enei   :  light wavelength in vacuum

[ p, hmat ] = deal( obj.p, obj.hmat );
%  fill full matrices
fun = @( row, col ) eval( obj.g, i, j, key, enei, sub2ind( [ p.n, p.n ], row, col ) );
%  compute full matrices
hmat = fillval( hmat, fun );

%  size of clusters
tree = hmat.tree;
siz = tree.cind( :, 2 ) - tree.cind( :, 1 ) + 1;
%  allocate low-rank matrices
hmat.lhs = arrayfun( @( x ) zeros( x, 1 ), siz( hmat.row2 ), 'uniform', 0 );
hmat.rhs = arrayfun( @( x ) zeros( x, 1 ), siz( hmat.col2 ), 'uniform', 0 );


%  connectivity matrix
con = obj.g.con{ i, j };
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
    ii = uintmex( i );
    jj = uintmex( j );
    %  compute low-rank matrix using ACA
    switch key
      case 'G'
        [ L, R ] = hmatgreenret( pmex, tmex, 'G', ii, jj, complex( con( i, j ) ), op );  
      case { 'F', 'H1', 'H2' }
        [ L, R ] = hmatgreenret( pmex, tmex, 'F', ii, jj, complex( con( i, j ) ), op );
    end    
    %  index to low-rank matrices
    ind = cellfun( @( x ) ~isempty( x ), L, 'uniform', 1 );
    %  set low-rank matrices
    hmat.lhs( ind ) = L( ind );
    hmat.rhs( ind ) = R( ind );
  end
end
end