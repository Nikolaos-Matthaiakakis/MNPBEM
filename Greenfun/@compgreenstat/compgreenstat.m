classdef compgreenstat < bembase
  %  Green function for composite points and particle in quasistatic
  %  approximation.

  %%  Properties
  properties (Constant)
    name = 'greenfunction'
    needs = { struct( 'sim', 'stat' ) }
  end  
  
  properties
    p1      %  Green function between points p1 and comparticle p2
    p2      %  Green function between points p1 and comparticle p2
    g       %  Green functions connecting p1 and p2    
  end
    
  %%  Methods  
  methods 
    function obj = compgreenstat( varargin )
      %  Initialize Green functions for composite objects.
      %  
      %  Usage :
      %    obj = compgreenstat( p1, p2 )
      %    obj = compgreenstat( p1, p2, op )
      %  Input
      %    p1   :  Green function between points p1 and comparticle p2
      %    p2   :  Green function between points p1 and comparticle p2
      %    op   :  options (see BEMOPTIONS)
      obj = init( obj, varargin{ : } );      
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'compgreenstat : ' );
      disp( struct( 'p1', obj.p1, 'p2', obj.p2, 'g', obj.g ) );
    end    
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
    
end
