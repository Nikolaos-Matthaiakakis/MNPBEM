function varargout = round( obj, varargin )
%  ROUND - Round z-values to achieve minimal distance to layers.
%
%  Usage for obj = layerstructure :
%    [ z1, z2, ... ] = mindist( obj, z1, z2, ... )
%  Input
%    z        :  z-values of points
%  Output
%    z        :  z-values with a minimal distance to layers

varargout = cell( size( varargin ) );

%  z-value of layer
ztab = @( ind ) reshape( obj.z( ind ), size( ind ) );

for i = 1 : length( varargin )
  %  z-value
  z = varargin{ i };
  %  minimal distance to layer
  [ zmin, ind ] = mindist( obj, z );
  %  shift direction
  dir = sign( z - ztab( ind ) );
  %  shift points that are too close to layer
  z( zmin <= obj.zmin ) =  ...
     ztab( ind( zmin <= obj.zmin ) ) + dir( zmin <= obj.zmin ) * obj.zmin;
  %  assign output
  varargout{ i } = z;
end
