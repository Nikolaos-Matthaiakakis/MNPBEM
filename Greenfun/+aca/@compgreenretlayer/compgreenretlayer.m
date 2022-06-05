classdef compgreenretlayer
  %  Green function for particle and layer structure using full Maxwell's
  %  equations and ACA.
  
  %%  Properties
  properties
    p       %  COMPARTICLE object
    layer   %  layer structure
    g       %  Green function connecting particle boundaries
    hmat    %  template for H-matrix     
  end
  
  properties (Access = private)
    ind           %  starting cluster index for given particle
    rmod = 'log'  %  'log' for logspace r-table or 'lin' for linspace
    zmod = 'log'  %  'log' for logspace z-table or 'lin' for linspace    
  end
  
  %%  Methods  
  methods 
    function obj = compgreenretlayer( varargin )
      %  Initialize Green functions for composite objects.
      %  
      %  Usage :
      %    obj = aca.compgreenretlayer( p, op )
      %  Input
      %    p    :  COMPARTICLE object
      %    op   :  options (see BEMOPTIONS) 
      obj = init( obj, varargin{ : } );      
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'aca.compgreenretlayer : ' );
      disp( struct( 'p', obj.p, 'layer', obj.layer,  ...
                    'g', obj.g, 'hmat',  obj.hmat ) );
    end
  end
  
end
