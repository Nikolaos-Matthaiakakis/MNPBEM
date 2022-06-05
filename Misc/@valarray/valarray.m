classdef valarray
  %  Value array for plotting.
  
  %%  Properties
  properties
    p                   %  particle
    val                 %  value array
    truecolor = false   %  true color array
  end
  
  properties
    h = []              %  handle of graphics object
  end
    
  %%  Methods
  methods
    
    function obj = valarray( varargin )
      %  Initialization of VALARRAY.
      %
      %  Usage :
      %    obj = valarray( p )
      %    obj = valarray( p, val )
      %    obj = valarray( p, val, 'truecolor' )
      %  Input
      %    p    :  particle
      %    val  :  value array
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'valarray : ' );  
      disp( struct( 'p', obj.p, 'val', obj.val, 'truecolor', obj.truecolor ) );
    end    
  end
  
end