function obj = init( obj, p, varargin )
%  INIT - Initialize composite Green function.

op = getbemoptions( varargin{ : } );
%  save particle and layer structure
[ obj.p, obj.layer ] = deal( p, op.layer );
%  grid for tabulated Green functions
if isfield( op, 'rmod' ),  obj.rmod = op.rmod;  end
if isfield( op, 'zmod' ),  obj.zmod = op.zmod;  end
%  initialize COMPGREEN object 
obj.g = compgreenretlayer( p, p, varargin{ : } );

%  make cluster tree
tree = clustertree( p, varargin{ : } );
%  template for H-matrix
obj.hmat = hmatrix( tree, varargin{ : } );


%  particle index for cluster 
ind1 = ipart( p, reshape( tree.ind( tree.cind( :, 1 ), 1 ), 1, [] ) );
ind2 = ipart( p, reshape( tree.ind( tree.cind( :, 2 ), 1 ), 1, [] ) );
%  cluster index 
obj.ind = zeros( 1, p.np );
for i = 1 : p.np
  obj.ind( i ) = find( ind1 == i & ind2 == i, 1 );
end
