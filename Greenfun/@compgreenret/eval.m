function varargout = eval( obj, varargin )
%  EVAL - Evaluate retarded Green function.
%
%  Deals with calls to obj = compgreenret :
%    g = obj{ i, j }.G( enei      )
%    g = obj{ i, j }.G( enei, ind )
%
%  Usage for obj = compgreenret :
%    g = eval( obj, i, j, key, enei      )
%    g = eval( obj, i, j, key, enei, ind )
%  Input
%    key    :  G    -  Green function
%              F    -  Surface derivative of Green function
%              H1   -  F + 2 * pi
%              H2   -  F - 2 * pi
%              Gp   -  derivative of Green function
%              H1p  -  Gp + 2 * pi
%              H2p  -  Gp - 2 * pi
%    enei   :  light wavelength in vacuum
%    ind    :  index to selected matrix elements

if nargin == 5
  %  compute full matrix
  [ varargout{ 1 : nargout } ] = eval1( obj, varargin{ : } );
elseif nargin == 6
  %  compute selected matrix elements
  [ varargout{ 1 : nargout } ] = eval2( obj, varargin{ : } );
end
 