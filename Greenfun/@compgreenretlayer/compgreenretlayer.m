classdef compgreenretlayer < bembase
  %  Green function for layer structure.

  %%  Properties
  properties (Constant)
    name = 'greenfunction'
    needs = { struct( 'sim', 'ret' ), 'layer' }
  end

  properties
    p1      %  Green function between points p1 and comparticle p2
    p2      %  Green function between points p1 and comparticle p2
    g       %  Green functions connecting p1 and p2 
    gr      %  reflected parts of Green functions
    layer   %  layer structure
  end
  
  properties
    ind1    %  index to positions of P1 connected to layer structure
    ind2    %  index to boundary elements of P2 connected to layer structure
  end
  
  %%  Methods  
  methods 
    function obj = compgreenretlayer( p1, p2, varargin )
      %  Initialize Green function object for layer structure.
      %  
      %  Usage :
      %    obj = compgreenretlayer( p1, p2, op )
      %    obj = compgreenretlayer( p1, p2, op, PropertyPair )      
      %  Input
      %    p1   :  Green function between points p1 and comparticle p2
      %    p2   :  Green function between points p1 and comparticle p2
      %    op   :  options (see BEMOPTIONS)
      obj.p1 = p1;
      obj.p2 = p2;
      %  initialize Green function
      obj = init( obj, varargin{ : } );      
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'compgreenretlayer : ' );
      disp( struct( 'p1', obj.p1, 'p2', obj.p2,  ...
                                   'g', obj.g, 'gr', obj.gr ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
