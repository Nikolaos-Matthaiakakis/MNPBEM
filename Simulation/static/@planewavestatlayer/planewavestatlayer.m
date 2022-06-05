classdef planewavestatlayer < bembase
  %  Plane wave excitation within quasistatic approximation for layer structure.

  %%  Properties
  properties (Constant)
    name = 'planewave'
    needs = { struct( 'sim', 'stat' ), 'layer' }
  end
  
  properties
    pol         %  light polarization
    dir         %  light propagation direction
    layer       %  layer structure
    spec        %  spectrum
  end
   
  %%  Methods  
  methods 
    function obj = planewavestatlayer( varargin )
      %  Initialize plane wave excitation.
      %  
      %  Usage :
      %    obj = planewavestatlayer( pol, dir, op, PropertyName, PropertyValue )      
      %  Input
      %    pol              :  light polarization
      %    dir              :  light propagation direction
      %    op               :  option structure including layer structure
      %    PropertyName     :  additional properties
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'planewavestatlayer : ' );
      disp( struct( 'pol', obj.pol, 'dir', obj.dir, 'layer', obj.layer ) );
    end    
  end
  
  methods (Access = private)
    obj = init( ob, varargin );
  end
end
