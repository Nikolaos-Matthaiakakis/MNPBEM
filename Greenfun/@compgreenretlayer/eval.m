function varargout = eval( obj, varargin )
%  EVAL - Evaluate Green function.
%
%  Usage for obj = compgreenretlayer :
%    varargout = eval( obj, i1, i2, enei, key )
%    varargout = eval( obj, i1, i2, enei, key, ind )
%  Input
%    i1     :  inner/outer surface of P1
%    i2     :  inner/outer surface of P2
%    enei   :  light wavelength in vacuum
%    key    :  G    -  Green functions
%              F    -  surface derivatives of Green functions
%              H    -  F + 2 * pi
%              H    -  F - 2 * pi
%              Gp   -  derivatives of Green functions
%              H1p  -  Gp + 2 * pi
%              H2p  -  Gp - 2 * pi
%  Output
%    g      :  requested Green functions
%    ind    :  index to selected matrix elements

if nargin == 5
  %  compute full matrix
  [ varargout{ 1 : nargout } ] = eval1( obj, varargin{ : } );
elseif nargin == 6
  %  compute selected matrix elements
  [ varargout{ 1 : nargout } ] = eval2( obj, varargin{ : } );
end
