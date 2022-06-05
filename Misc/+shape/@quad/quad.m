classdef quad
  %  Quadrilateral shape element.
  
  %%  Properties
  properties
    node    %  number of nodes
  end
  
  %%  Methods
  methods
    function obj = quad( node )
      %  Initialize quadrilateral shape element.
      %
      %  Usage :
      %    obj = quad( node )
      %  Input
      %    node     :  number of nodes (4 or 9)
      obj.node = node;
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'quad : ' );
      disp( struct( 'node', obj.node ) );
    end  
  end
end