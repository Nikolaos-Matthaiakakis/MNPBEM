classdef polygon3
  %  3D polygon for extrusion of particles.
  
%%  Properties
  properties
    poly        %  polygon
    z           %  z-value of polygon
    edge = []   %  edge profile
  end
  
  properties (Access = private)
    refun       %  refine function for plate discretization
  end
    
%%  Methods
  methods
    function obj = polygon3( varargin )
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
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      if numel( obj ) ~= 1 
        siz = strrep( mat2str( size( obj ) ), ' ', 'x' );
        fprintf( '\n%s polygon3 array\n\n', siz );
      else      
        disp( 'polygon3 : ' );
        disp( struct( 'poly', obj.poly, 'z', obj.z, 'edge', obj.edge ) );
      end
    end   
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
