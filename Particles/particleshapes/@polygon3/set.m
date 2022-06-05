function obj = set( obj, varargin )
%  SET - Set properties of POLYGON3 objects.
%
%  Usage for obj = polygon3 :
%    obj = set( obj, PropertyPair )
%  PropertyName
%    'z'      :  z-value 
%    'dir'    :  direction up +1 or down -1 for extrusion
%    'edge'   :  edge profile

for i = 1 : numel( obj )
  for j = 1 : 2 : numel( varargin )
    try
      obj( i ).( varargin{ j } ) = varargin{ j + 1 };
    catch
      %  set values of POLYGON
      obj( i ).poly.( varargin{ j } ) = varargin{ j + 1 };
    end
  end
end
