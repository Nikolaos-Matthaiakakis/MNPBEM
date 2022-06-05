classdef igrid2
  %  2d grid for interpolation
  
%%  Properties
  properties
    x       %  x-values of grid
    y       %  y-values of grid
  end
    
%%  Methods
  methods
    function obj = igrid2( x, y )
      %  Initialize 2d grid for interpolation.
      %
      %  Usage
      %    obj = igrid2( x, y )
      %  Input
      %    x    :  x-values of grid
      %    y    :  y-values of grid
      [ obj.x, obj.y ] = deal( x, y );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'igrid2 : ' );
      disp( struct( 'x', obj.x, 'y', obj.y ) );
    end   
  end
  
end