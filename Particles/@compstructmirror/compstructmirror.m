classdef compstructmirror
  %  Structure for compound of points or particles with mirror symmetry.
  
  %%  Properties
  properties
    p           %  points or discretized particle surface
    enei        %  light wavelength in vacuum
    val         %  cell with COMPSTRUCT objects
    fun         %  expansion function
  end

  %%  Methods
  methods
    
    function obj = compstructmirror( p, enei, fun )
      %  Initialization of COMPSTRUCTMIRROR object.
      %
      %  Usage :
      %    obj = compstructmirror( p, enei, fun )
      %  Input
      %    p     :  points or discretized particle surface
      %    enei  : light wavelength in vacuum
      %    fun   :  expansion function
      [ obj.p, obj.enei, obj.fun ] = deal( p, enei, fun );
    end
        
    function display( obj )
      %  Command window display.
      disp( 'compstructmirror : ' );      
      disp( struct( 'p', obj.p, 'enei', obj.enei,  ...
                                 'val', { obj.val }, 'fun', obj.fun ) );
    end
    
    function varargout = full( obj )
      %  FULL - Expand object with mirror symmetry to full size.
      [ varargout{ 1 : nargout } ] = obj.fun( obj );
    end 
  end

end
