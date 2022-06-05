classdef tri
  %  Triangular shape element.
  
  %%  Properties
  properties
    node    %  number of nodes
  end
  
  %%  Methods
  methods
    function obj = tri( node )
      %  Initialize triangular shape element.
      %
      %  Usage :
      %    obj = tri( node )
      %  Input
      %    node     :  number of nodes (3 or 6)
      obj.node = node;
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'tri : ' );
      disp( struct( 'node', obj.node ) );
    end  
  end
  
end