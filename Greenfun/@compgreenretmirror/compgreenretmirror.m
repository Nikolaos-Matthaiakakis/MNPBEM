classdef compgreenretmirror < bembase
  %  Green function for composite particles with mirror symmetry.
  
  %%  Properties
   properties (Constant)
    name = 'greenfunction'
    needs = { struct( 'sim', 'ret' ), 'sym' }
   end
  
  properties
    p       %  Green function for particle p with mirror symmetry
    g       %  Green functions connecting p1 and p2 
  end

  %%  Methods
  methods
    function obj = compgreenretmirror( p, ~, varargin )
      %  Initialize Green functions for composite object & mirror symmetry.
      %  
      %  Usage :
      %    obj = compgreenretmirror( p, ~ )
      %    obj = compgreenretmirror( p, ~, op )
      %  Input
      %    p    :  Green function for particle p with mirror symmetry
      %              the second dummy input is introduced to have the same
      %              calling sequence as with compgreen
      %    op   :  see green/options
      obj.p = p;
      %  initialize Green function
      obj.g = compgreenret( p, full( p ), varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'compgreenretmirror : ' );
      disp( struct( 'p', obj.p, 'g', obj.g ) );
    end
        
  end
  
end
