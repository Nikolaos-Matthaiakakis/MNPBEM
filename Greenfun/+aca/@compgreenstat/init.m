function obj = init( obj, p, varargin )
%  INIT - initialize composite Green function.

%  save particle
obj.p = p;
%  initialize COMPGREEN object
obj.g = compgreenstat( p, p, varargin{ : } );

%  make cluster tree
tree = clustertree( p, varargin{ : } );
%  template for H-matrix
obj.hmat = hmatrix( tree, varargin{ : } );
