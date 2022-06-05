function g = eval2( obj, i, j, key, enei )
%  EVAL2 - Evaluate retarded Green function for layer structure (reflected).
%
%  Deals with calls to obj = aca.compgreenretlayer :
%    g = obj{ i, j }.G( enei )
%
%  Usage for obj = aca.compgreenretlayer :
%    g = eval2( obj, i, j, key, enei )
%  Input
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%    enei   :  light wavelength in vacuum

hmat = obj.hmat;
%  cluster tree 
tree = hmat.tree;

%  matrix indices for full matrices
[ ind, siz, n ] = arrayfun( @( row, col )  ...
         matindex( tree, tree, row, col ),  hmat.row1, hmat.col1, 'uniform', 0 );
%  full matrices of Green function for layer structure
val = eval( obj.g, i, j, key, enei, vertcat( ind{ : } ) );
%  low-rank matrices for direct Green function interaction
[ lhs, rhs ] = lowrank1( obj, i, j, key, enei );

%  loop over names 
for name = fieldnames( val ) .'
  %  fill full matrices
  mat = mat2cell( val.( name{ 1 } ), cell2mat( n ), 1 );
  val1 = cellfun( @( mat, siz ) reshape( mat, siz ), mat, siz, 'uniform', 0 );
  
  %  fill low-rank matrices (direct)
  switch name{ 1 }
    case { 'p', 'ss', 'hh' }
      [ lhs1, rhs1 ] = deal( lhs, rhs );
    otherwise
      lhs1 = cellfun( @( lhs ) zeros( size( lhs, 1 ), 1 ), lhs, 'uniform', 0 );
      rhs1 = cellfun( @( rhs ) zeros( size( rhs, 1 ), 1 ), rhs, 'uniform', 0 );
  end
  %  fill low-rank matrix (reflected)
  [ lhs2, rhs2 ] = lowrank2( obj, key, name{ 1 }, enei );
   
  %  assign output
  g.( name{ 1 } ) = hmat;
  %  set full matrices
  g.( name{ 1 } ).val = val1;
  %  set low-rank matrices
  g.( name{ 1 } ).lhs = cellfun( @( lhs1, lhs2 ) [ lhs1, lhs2 ], lhs1, lhs2, 'uniform', 0 );
  g.( name{ 1 } ).rhs = cellfun( @( rhs1, rhs2 ) [ rhs1, rhs2 ], rhs1, rhs2, 'uniform', 0 );
  
  %  truncate matrix
  g.( name{ 1 } ) = truncate( g.( name{ 1 } ), hmat.htol );
end
