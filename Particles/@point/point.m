classdef point
  %  Collection of points.
  
  %%  Properties
  properties
    pos         %  coordinates of points
    vec         %  basis vectors at positions
  end  
  
  %%  Methods
  methods
    function obj = point( pos, vec )
      %  Set properties of compoint.
      %
      %  Usage :
      %    pt = point( pos, vec )
      %  Input
      %    pos      :  coordinates of points
      %    vec      :  basis vectors { x, y, z } at positions
      %                  use [] to set default values
      obj.pos =   pos;
      %  basis vectors
      if exist( 'vec', 'var' ) && ~isempty( vec )
        obj.vec = { vec };
      else
        n = size( pos, 1 );
        obj.vec = { repmat( [ 1, 0, 0 ], n, 1 ),  ...
                    repmat( [ 0, 1, 0 ], n, 1 ),  ...
                    repmat( [ 0, 0, 1 ], n, 1 ) };
      end
    end
    
    function display( obj )
      %  Command window display.
      disp( 'point : ' );
      disp( struct( 'pos', obj.pos, 'vec', { obj.vec } ) );
    end
    
  end
  
end
