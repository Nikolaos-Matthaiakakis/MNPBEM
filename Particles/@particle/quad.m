function varargout = quad( obj, varargin )
%  QUAD - Quadrature points and weights for boundary element integration.
%
%  Usage for obj = particle :
%    [ pos, w, iface ] = quad( obj, ind )
%  Input
%    ind    :  face index or indices
%  Output
%    pos    :  integration points
%    w      :  integration weights
%    iface  :  face index for integration points

%  use routine for flat or curved particle boundary
switch obj.interp
  case 'flat'
    [ varargout{ 1 : nargout } ] = quad_flat( obj, varargin{ : } );
  case 'curv'
    [ varargout{ 1 : nargout } ] = quad_curv( obj, varargin{ : } );
end
