classdef compgreenret < bembase
  %  Green function for composite points and particle.

  %%  Properties
  properties (Constant)
    name = 'greenfunction'
    needs = { struct( 'sim', 'ret' ) }
  end

  properties
    p1      %  Green function between points p1 and comparticle p2
    p2      %  Green function between points p1 and comparticle p2
    con     %  connectivity matrix between points of p1 and p2
    g       %  Green functions connecting p1 and p2 
    hmode   %  'aca1', 'aca2', 'svd' for initialization of H-matrices
  end
  
  properties %(Access = private)  
    block   %  block matrix for evaluation of selected Green function elements
    hmat    %  template for hierarchical matrices      
  end
  
  %%  Methods  
  methods 
    function obj = compgreenret( varargin )
      %  Initialize Green functions for composite objects.
      %  
      %  Usage :
      %    obj = compgreenret( p1, p2 )
      %    obj = compgreenret( p1, p2, op )
      %  Input
      %    p1   :  Green function between points p1 and comparticle p2
      %    p2   :  Green function between points p1 and comparticle p2
      %    op   :  options (see BEMOPTIONS) 
      obj = init( obj, varargin{ : } );      
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'compgreenret : ' );
      disp( struct( 'p1', obj.p1, 'p2', obj.p2,  ...
              'con', { obj.con }, 'g', { obj.g }, 'hmode', obj.hmode ) );
    end
  end
    
end
