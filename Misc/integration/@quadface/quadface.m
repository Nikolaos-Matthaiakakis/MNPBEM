classdef quadface
  %  Integration over triangular or quadrilateral boundary elements.
  
  %%  Properties
  properties
    x       %  x coordinates of integration points
    y       %  y coordinates of integration points
    w       %  weights for triangle integration
    npol    %  number of integration points for polar integration
  end
  
  properties
    x3      %  x coordinates for polar triangle integration
    y3      %  y coordinates for polar triangle integration
    w3      %  weights for polar triangle integration
    x4      %  x coordinates for polar quadrilateral integration
    y4      %  y coordinates for polar quadrilateral integration
    w4      %  weights for polar quadrilateral integration
  end
 
  %%  Methods
  methods
  
    function obj = quadface( varargin )
      %  Initialize quadface object.
      %
      %  Usage :
      %    obj = quadface
      %    obj = quadface( op, 'PropertyName', Propertyvalue )
      %    obj = quadface(     'PropertyName', Propertyvalue )
      %  PropertyName
      %    op           :  option structure
      %    'rule'       :  integration rule (1-19, see triangle_unit_set)
      %    'refine'     :  refine surface element
      %    'npol'       :  number of points for polar integration
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'quadface :' );
      disp( struct( 'x', obj.x, 'y', obj.y, 'w', obj.w, 'npol', obj.npol ) );
    end
  end 
  
end