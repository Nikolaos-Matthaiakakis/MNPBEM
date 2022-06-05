function varargout = eval( obj, varargin )
%  EVAL - Evaluate Green function.
%
%  Usage for obj = greenstat :
%    varargout = eval( obj,      key1, key2, ... )
%    varargout = eval( obj, ind, key1, key2, ... )
%  Input
%    ind    :  index to matrix elements to be computed
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%              Gp   -  derivative of Green function
%              H1p  -  Gp + 2 * pi
%              H2p  -  Gp - 2 * pi
%  Output
%    varargout  :  requested Green functions

if ischar( varargin{ 1 } )
  [ varargout{ 1 : nargout } ] = eval1( obj, varargin{ : } );
else
  [ varargout{ 1 : nargout } ] = eval2( obj, varargin{ : } );
end
