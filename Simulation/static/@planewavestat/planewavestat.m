classdef planewavestat < bembase
  %  Plane wave excitation within quasistatic approximation.

  %%  Properties
  properties (Constant)
    name = 'planewave'
    needs = { struct( 'sim', 'stat' ) }
  end
  
  properties
    pol         %  light polarization
    medium = 1  %  compute spectra in given medium
  end
  
  %%  Methods  
  methods 
    function obj = planewavestat( varargin )
      %  Initialize plane wave excitation.
      %  
      %  Usage :
      %    obj = planewavestat( pol,      op, PropertyName, PropertyValue )
      %    obj = planewavestat( pol, dir, op, PropertyName, PropertyValue )      
      %  Input
      %    pol              :  light polarization
      %    op               :  options 
      %    PropertyName     :  additional properties
      %                          either OP or PropertyName can contain a
      %                          field 'medium' that selects the medium
      %                          through which the particle is excited
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'planewavestat : ' );
      disp( struct( 'pol', obj.pol, 'medium', obj.medium ) );
    end    
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
