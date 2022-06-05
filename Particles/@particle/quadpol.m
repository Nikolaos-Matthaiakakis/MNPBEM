function varargout = quadpol( obj, varargin )
%  QUADPOL - Quadrature points and weights for boundary element
%            integration in polar coordinates.
%
%  Usage for obj = particle :
%    [ pos, weight, row ] = quadpol( obj, ind )
%  Input
%    ind    :  face index or indices
%  Output
%    pos    :  integration points
%    weight  :  integration weights
%    row     :  to perform an integration inside the elements use
%                 accumarray( row, weight .* fun( pos ) )

%  use routine for flat or curved particle boundary
switch obj.interp
  case 'flat'
    [ varargout{ 1 : nargout } ] = quadpol_flat( obj, varargin{ : } );
  case 'curv'
    [ varargout{ 1 : nargout } ] = quadpol_curv( obj, varargin{ : } );
end
