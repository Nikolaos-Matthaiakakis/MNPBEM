classdef polygon
  %  2D polygons for use with Mesh2d.
  
%%  Properties
  properties
    pos     %  positions of polygon vertices
    dir     %  direction of polygon (clockwise or counterclockwise)
    sym     %  symmetry keyword [], 'x', 'y', or 'xy'
  end

%%  Methods
  methods
    
    function obj = polygon( varargin )
      %  Initialize polygon.
      %
      %  Usage :
      %    obj = polygon(      n, 'PropertyName', PropertyValue, ... )
      %    obj = polygon( 'n', n, 'PropertyName', PropertyValue, ... )
      %      Initialize polygon with n vertices
      %    obj = polygon( 'pos', pos, 'PropertyName', PropertyValue, ... )
      %      Initialize polygon with given positions
      %  PropertyName
      %    'dir'  :  direction of polygon (clockwise or counterclockwise)
      %    'sym'  :  symmetry keyword [], 'x', 'y', or 'xy'
      %    'size' :  scale polygon with [ size( 1 ), size( 2 ) ]
      [ obj.pos, obj.dir, obj.sym ] = init( varargin{ : } );
      
      if ~isempty( obj.sym );  obj = symmetry( obj, obj.sym );  end
    end
    
    function display( obj )
      % Command window display.
      disp( 'polygon : ' );
      for i = 1 : length( obj )
        disp( struct( 'pos', obj( i ).pos, 'dir', obj( i ).dir,  ...
                                           'sym', obj( i ).sym ) );
      end 
    end
    
  end
  
end
