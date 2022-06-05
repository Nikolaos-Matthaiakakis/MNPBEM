function obj = init( obj, p1, p2, varargin )
%  INIT - Initialize composite Green function.

%  save particles and points
[ obj.p1, obj.p2 ] = deal( p1, p2 );
%  initialize Green function
g = greenret( p1, p2, varargin{ : } );
%  deal with closed argument 
g = initclosed( g, p1, p2, varargin{ : } );
%  split Green function
obj.g = mat2cell( g, p1.p, p2.p );

%  connectivity matrix
obj.con = connect( p1, p2 );
%  size of point or particle objects
siz1 = cellfun( @( p ) p.n, p1.p, 'uniform', 1 );
siz2 = cellfun( @( p ) p.n, p2.p, 'uniform', 1 );
%  block matrix for evaluation of selected Green function elements
obj.block = blockmatrix( siz1, siz2 );

op = getbemoptions( { 'green', 'greenret' }, varargin{ : } );
%  hierarchical matrices ?
if isfield( op, 'hmode' ) && ~isempty( op.hmode )
  %  mode for hierarchical matrices, 'aca1', 'aca2', 'svd'
  obj.hmode = op.hmode;
  %  set up cluster trees
  tree1 = clustertree( p1, op );
  tree2 = clustertree( p2, op );
  %  initialize hierarchical matrix
  obj.hmat = hmatrix( tree1, tree2, op );
end
