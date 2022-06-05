classdef compstruct
  %  Structure for compound of points or particles.
  %    COMPSTRUCT contains 
  %      - a reference of the points or particles,
  %      - the light wavelength in vacuum, and 
  %      - an arbitrary number of additional fields.
  %    For the fields the operations +, -, *, / are defined as for
  %    normal arrays.
  
  %%  Properties
  properties
    p       %  points or discretized particle surface
    enei    %  light wavelength in vacuum
  end
  
  properties
    val     %  structure that holds addtitonal fields
  end

  %%  Methods
  methods
    
    function obj = compstruct( p, varargin )
      %  Initialize compstruct.
      %
      %  Usage :
      %    obj = compstruct( p )
      %    obj = compstruct( p,       'PropertyName', PropertyValue, ... )
      %    obj = compstruct( p, enei, 'PropertyName', PropertyValue, ... )
      %  Input
      %    p    :  compound of particles or other compstruct object
      %    enei :  light wavelength in vacuum
      
      if isa( p, 'compstruct' )
        [ obj.p, obj.enei, obj.val ] = deal( p.p, p.enei, p.val );
      else
        obj.p = p;
      end
      
      %  deal with other input arguments
      if nargin > 1 && isnumeric( varargin{ 1 } )
        obj.enei = varargin{ 1 };
        obj = set( obj, varargin{ 2 : end } );
      else
        obj = set( obj, varargin{ : } );
      end
    end
        
    function display( obj )
      %  Command window display.
      disp( 'compstruct : ' );
      disp( setfield(  ...
            setfield( obj.val, 'p', obj.p ), 'enei', obj.enei ) );
    end
        
  end

end
