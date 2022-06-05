classdef planewavestatmirror < bembase
  %  Plane wave excitation within quasistatic approximation for particle
  %  with mirror symmetry.

  %%  Properties
  properties (Constant)
    name = 'planewave'
    needs = { struct( 'sim', 'stat' ), 'sym' }
  end

  properties
    pol         %  light polarization
  end
  
  properties (Access = private)
    exc         %  plane wave excitation (see PLANEWAVESTAT)
  end
  
  %%  Methods  
  methods 
    function obj = planewavestatmirror( pol, varargin )
      %  Initialize plane wave excitation with mirror symmetry.
      %  
      %  Usage :
      %    obj = planewavestatmirror( pol,      op, PropertyName, PropertyValue )
      %    obj = planewavestatmirror( pol, dir, op, PropertyName, PropertyValue )      
      %  Input
      %    pol              :  light polarization
      %    op               :  options 
      %    PropertyName     :  additional properties
      %                          either OP or PropertyName can contain a
      %                          field 'medium' that selects the medium
      %                          through which the particle is excited
      obj.pol = pol;
      obj.exc = planewavestat( pol, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'planewavestatmirror : ' );
      disp( struct( 'pol', obj.pol, 'medium', obj.exc.medium ) );
    end    
  end
    
end
