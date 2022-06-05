function varargout = interp( obj, varargin )
%  INTERP - Interpolate tabulated Green functions.
%
%  Usage for obj = greentablayer :
%    [ G, Fr, Fz, r, zmin ] = interp( obj, r, z1, z2 )
%  Input
%    r       :  radii
%    z1, z2  :  z-distances
%  Output
%    G       :  Green function
%    Fr      :  derivative of Green function along radius
%    Fz      :  derivative of Green function along z
%    r       :  radius as used in interpolation
%    zmin    :  minimal distance to layers as used in interpolation

%  interpolation in uppermost or lowermost layer
if numel( obj.z2 ) == 1
  [ varargout{ 1 : nargout } ] = interp2( obj, varargin{ : } );
else
  [ varargout{ 1 : nargout } ] = interp3( obj, varargin{ : } );
end
