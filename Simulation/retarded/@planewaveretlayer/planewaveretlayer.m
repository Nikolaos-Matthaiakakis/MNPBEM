classdef planewaveretlayer < bembase
  %  Plane wave excitation for layer structure.

  %%  Properties
  properties (Constant)
    name = 'planewave'
    needs = { struct( 'sim', 'ret' ), 'layer' }
  end
  
  properties
    pol         %  light polarization
    dir         %  light propagation direction
    layer       %  layer structure
  end
  
  properties (Access = private)
    spec        %  spectrum
  end
  
%%  Methods  
  methods 
    function obj = planewaveretlayer( varargin )
      %  Initialize plane wave excitation for layer structure.
      %  
      %  Usage :
      %    obj = planewaveretlayer( pol, dir, op, PropertyPair )
      %  Input
      %    pol      :  light polarization
      %    dir      :  light propagation direction
      %    op               :  options 
      %    PropertyName     :  additional properties
      %                          either OP or PropertyName can contain
      %                          fields 'layer' or 'pinfty' that select the
      %                          layer structure or the sphere at infinity
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'planewaveretlayer : ' );
      disp( struct( 'pol', obj.pol, 'dir', obj.dir, 'layer', obj.layer ) );
    end
    
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
