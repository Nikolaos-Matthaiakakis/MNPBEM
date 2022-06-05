classdef compgreenstat 
  %  Green function for particle in quasistatic approximation using ACA.

  %%  Properties

  properties
    p       %  COMPARTICLE object
    g       %  COMPGREENSTAT object
    hmat    %  template for H-matrix
  end
    
  %%  Methods  
  methods 
    function obj = compgreenstat( varargin )
      %  Initialize Green function for COMPARTICLE.
      %  
      %  Usage :
      %    obj = compgreenstat( p, op )
      %  Input
      %    p    :  COMPARTICLE object
      %    op   :  options (see BEMOPTIONS)
      obj = init( obj, varargin{ : } );      
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'aca.compgreenstat : ' );
      disp( struct( 'p', obj.p, 'g', obj.g, 'hmat', obj.hmat ) );
    end    
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
    
end
