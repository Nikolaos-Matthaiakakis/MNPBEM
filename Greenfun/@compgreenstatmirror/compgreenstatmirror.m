classdef compgreenstatmirror < bembase
  %  Quasistatic Green function for composite particles with mirror symmetry.
  
  %%  Properties
  properties (Constant)
    name = 'greenfunction'
    needs = { struct( 'sim', 'stat' ), 'sym' }
  end  
  
  properties
    p       %  Green function for particle p with mirror symmetry
    g       %  Green functions connecting p1 and p2 
  end

  %%  Methods
  methods
    function obj = compgreenstatmirror( p, ~, varargin )
      %  Initialize Green functions for composite object and mirror symmetry.
      %  
      %  Usage :
      %    obj = compgreenstatmirror( p, varargin )
      %  Input
      %    p    :  Green function for particle p with mirror symmetry
      %              the second dummy input is introduced to have the same
      %              calling sequence as with COMPGREENSTAT      
      [ obj.p, obj.g ] =  ...
        deal( p, compgreenstat( p, full( p ), varargin{ : } ) );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'compgreenstatmirror : ' );
      disp( struct( 'p', obj.p, 'g', obj.g ) );
    end
  end
  
end
