classdef igrid3
  %  3d grid for interpolation
  
%%  Properties
  properties
    x       %  x-values of grid
    y       %  y-values of grid
    z       %  z-values of grid
  end
    
%%  Methods
  methods
    function obj = igrid3( x, y, z )
      %  Initialize 3d grid for interpolation.
      %
      %  Usage
      %    obj = igrid3( x, y, z )
      %  Input
      %    x    :  x-values of grid
      %    y    :  y-values of grid
      %    z    :  z-values of grid
      [ obj.x, obj.y, obj.z ] = deal( x, y, z );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'igrid3 : ' );
      disp( struct( 'x', obj.x, 'y', obj.y, 'z', obj.z ) );
    end   
  end
  
end