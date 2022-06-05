classdef compgreenret
  %  Green function for particle using full Maxwell's equations and ACA.
  
  %%  Properties
  properties
    p       %  COMPARTICLE object
    g       %  Green functions connecting particle boundaries
    hmat    %  template for H-matrix     
  end
  
  %%  Methods  
  methods 
    function obj = compgreenret( varargin )
      %  Initialize Green functions for composite objects.
      %  
      %  Usage :
      %    obj = aca.compgreenret( p, op )
      %  Input
      %    p    :  COMPARTICLE object
      %    op   :  options (see BEMOPTIONS) 
      obj = init( obj, varargin{ : } );      
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'aca.compgreenret : ' );
      disp( struct( 'p', obj.p, 'g', { obj.g }, 'hmat', obj.hmat ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
    
end
