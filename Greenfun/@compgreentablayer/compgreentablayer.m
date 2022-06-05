classdef compgreentablayer
  %  Green function for layer structure and different media.
  %    COMPGREENTABLAYER computes the reflected Green function and its
  %    derivatives for a layer structure, and saves the results for a
  %    rectangular mesh of radial and height values.  The stored values can
  %    then be used for interpolation with arbitrary radial and height
  %    values.

  %%  Properties

  properties
    layer       %  layer structure
    g           %  cell array of tabulated Green functions
  end
    
  %%  Methods  
  methods 
    function obj = compgreentablayer( varargin )
      %  Initialize compound Green function object for layer structure.
      %  
      %  Usage :
      %    obj = compgreentablayer( layer, tab1, tab2, ... )
      %  Input
      %    layer    :  layer structure
      %    tab      :  grids for tabulated r and z-values
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'compgreentablayer : ' );
      disp( struct( 'layer', obj.layer, 'g', { obj.g } ) );
    end   
  end
 
  methods (Access = private)
    obj = init( obj, varargin );
  end
end
