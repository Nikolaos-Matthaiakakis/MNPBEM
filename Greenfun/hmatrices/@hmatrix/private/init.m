function obj = init( obj, tree, varargin )
%  INIT - Initialize hierarchical matrix.
%
%  Usage for obj = hmatrix :
%    obj = init( obj, tree, op, PropertyPairs )
%  Input
%    tree1    :  cluster tree 1
%    tree2    :  cluster tree 2
%  PropertyName
%    fadmiss  :  function for admissibility
%    htol     :  tolerance for low-rank approximation
%
%  See S. Boerm et al., Eng. Analysis with Bound. Elem. 27, 405 (2003).

op = getbemoptions( { 'iter', 'hoptions' }, varargin{ : } );
%  extract input
if isfield( op, 'htol' ),  obj.htol = op.htol;  end
if isfield( op, 'kmax' ),  obj.kmax = op.kmax;  end

%  save tree and compute admissibility matrix
obj.tree = tree;
admiss = admissibility( tree, tree, varargin{ : } );

%  indices for low-rank and full matrices
[ obj.row1, obj.col1 ] = find( admiss == 2 );
[ obj.row2, obj.col2 ] = find( admiss == 1 );
