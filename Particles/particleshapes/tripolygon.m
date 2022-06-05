function [ p, poly ] = tripolygon( poly, edge, varargin )
%  TRIPOLYGON - 3d particle from polygon.
%
%  Usage :
%    [ p, poly ] = tripolygon( poly, edge, PropertyPairs )
%  Input
%    poly        :  2d polygon
%    edge        :  edge profile
%  PropertyName
%    'hdata'     :  pass hdata to mesh2d
%    'opt'       :  pass options structure to mesh2d
%    'refine'    :  refine function for edges
%  Output
%    p          :  particle object for extruded particle
%    poly       :  edge polygon

%  rounded or sharp upper and lower edges
if all( ~isnan( edge.pos( :, 1 ) ) ) ||  ...
        ~( numel( find( edge.pos( :, 1 ) == 0 ) == 1 ) )
  %  polygon3 object
  poly1 = arrayfun( @( poly ) polygon3( poly, edge.zmin ), poly, 'UniformOutput', false );
  poly2 = arrayfun( @( poly ) polygon3( poly, edge.zmax ), poly, 'UniformOutput', false );
  %  plates
  [ plate1, ~    ] = plate( horzcat( poly1{ : } ), 'edge', edge, 'dir', -1, varargin{ : } );
  [ plate2, poly ] = plate( horzcat( poly2{ : } ), 'edge', edge, 'dir',  1, varargin{ : } );
  %  ribbon
  ribbon = vribbon( poly, varargin{ : } );
  
%  sharp lower edge  
elseif isnan( edge.pos( 1, 1 ) )
  %  polygon3 object
  poly = arrayfun( @( poly ) polygon3( poly, edge.zmax ), poly, 'UniformOutput', false );  
  %  upper plate
  [ plate1, poly ] = plate( horzcat( poly{ : } ), 'edge', edge, 'dir',  1, varargin{ : } );
  %  ribbon
  [ ribbon, ~, poly ] = vribbon( poly, varargin{ : } );  
  %  lower plate
  plate2 = plate( set( poly, 'z', edge.zmin ),    'edge', edge, 'dir', -1, varargin{ : } );
  
%  sharp upper edge  
else
  %  polygon3 object
  poly = arrayfun( @( poly ) polygon3( poly, edge.zmin ), poly, 'UniformOutput', false );  
  %  lower plate
  [ plate1, poly ] = plate( horzcat( poly{ : } ), 'edge', edge, 'dir', -1, varargin{ : } );
  %  ribbon
  [ ribbon, poly, ~ ] = vribbon( poly, varargin{ : } );  
  %  upper plate
  plate2 = plate( set( poly, 'z', edge.zmax ),    'edge', edge, 'dir',  1, varargin{ : } );
  
end

%  put together particle
p = clean( vertcat( plate1, plate2, ribbon ) ); 
