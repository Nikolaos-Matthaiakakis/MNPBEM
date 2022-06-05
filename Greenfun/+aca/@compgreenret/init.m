function obj = init( obj, p, varargin )
%  INIT - Initialize composite Green function.

%  save particle
obj.p = p;
%  initialize COMPGREEN object
obj.g = compgreenret( p, p, varargin{ : } );

%  make cluster tree
tree = clustertree( p, varargin{ : } );
%  template for H-matrix
obj.hmat = hmatrix( tree, varargin{ : } );
