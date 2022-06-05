classdef vecarray
  %  Vector array for plotting.
  
  %%  Properties
  properties
    pos                 %  vector positions
    vec                 %  vector array
    mode = 'cone'       %  'cone' or 'arrow'
  end
  
  properties
    h = []              %  handle of graphics object
    color = 'b'         %  color for 'arrow' plotting
  end
    
  %%  Methods
  methods
    
    function obj = vecarray( pos, vec, mode )
      %  Initialization of VECARRAY.
      %
      %  Usage :
      %    obj = vecarray( pos, vec )
      %    obj = vecarray( pos, vec )
      %  Input
      %    pos      :  vector positions
      %    vec      :  vector array
      %    mode     :  'cone' or 'arrow'
      
      [ obj.pos, obj.vec ] = deal( pos, vec );
      %  set MODE property
      if exist( 'mode', 'var' ),  obj.mode = mode;  end
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'vecarray : ' );  
      disp( struct( 'pos', obj.pos, 'vec', obj.vec, 'mode', obj.mode ) );
    end
  end
  
end