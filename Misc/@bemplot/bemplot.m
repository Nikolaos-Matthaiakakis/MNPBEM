classdef bemplot
  %  Plotting value arrays and vector functions within MNPBEM.
  %    BEMPLOT is stored as a UserData in the figure and allows to plot
  %    value and vector functions, and to page through multidimensional
  %    arrays.
  
  %%  Properties
  properties
    var = {}    
           %  value and vector arrays for plotting
    siz    %  size for paging plots
    opt    %  structure with options for plotting
           %    opt.ind    -  index for paging plots and additional functions
           %    opt.fun    -  plot function ('real', 'imag', 'abs', or user-defined)
           %    opt.scale  -  scale factor for vector array
           %    opt.sfun   -  scale function for vector array
  end
  
  %%  Methods
  methods
    
    function obj = bemplot( varargin )
      %  Initialization of BEMPLOT object.
      %
      %  Usage :
      %    obj = bemplot( PropertyPairs )
      %  PropertyValue
      %    'fun'    :  plot function 
      %    'scale'  :  scale factor for vector array
      %    'sfun'   :  scale function for vector array
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'bemplot : ' );
      disp( struct( 'var', { obj.var }, 'siz', obj.siz, 'opt', obj.opt ) );
    end        
  end
  
  methods (Static)
    obj = get( varargin );
    varargout = set( varargin );
  end
  
end