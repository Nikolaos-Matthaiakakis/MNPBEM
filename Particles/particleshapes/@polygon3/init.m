function obj = init( obj, poly, z, varargin )
%  Initialize polygon3 object.
%
%  Usage
%    obj = polygon3( poly, z )
%    obj = polygon3( poly, z, op, PropertyPairs )
%  Input
%    poly     :  polygon
%    z        :  z-value of polygon
%  PropertyName
%    'edge'   :  edge profile
%    'refun'  :  refine function for plate discretization

%  save input
[ obj.poly, obj.z ] = deal( poly, z );

%  extract input
op = getbemoptions( varargin{ : } );
%  extract input
if isfield( op, 'edge' ),   obj.edge  = op.edge;   end
if isfield( op, 'refun' ),  obj.refun = op.refun;  end

%  default value for edge profile
if isempty( obj.edge ),  obj.edge = edgeprofile;  end
 