classdef compgreenstatlayer < bembase
  %  Green function for layer structure in quasistatic limit.
  %    Works only for single layer and particle located in upper medium.
  %    The reflected part of the Green functions is computed using image
  %    charges.

  %%  Properties
  properties (Constant)
    name = 'greenfunction'
    needs = { struct( 'sim', 'stat' ), 'layer' }
  end

  properties
    p1      %  Green function between points p1 and comparticle p2
    p2      %  Green function between points p1 and comparticle p2
    layer   %  layer structure
    g       %  Green function object (direct term)
    gr      %  Green function object (reflected term)
  end
  
  properties 
    p2r     %  image particle (for reflected Green function)
    ind1    %  index to elements of P1 located above layer
    ind2    %  index to elements of P2 not located in layer
    indl    %  index to elements of P2     located in layer
  end
  
  %%  Methods  
  methods 
    function obj = compgreenstatlayer( p1, p2, varargin )
      %  Initialize Green function object for layer structure.
      %  
      %  Usage :
      %    obj = compgreenstatlayer( p1, p2, op )
      %    obj = compgreenstatlayer( p1, p2, op, PropertyPair )      
      %  Input
      %    p1   :  Green function between points p1 and comparticle p2
      %    p2   :  Green function between points p1 and comparticle p2
      %    op   :  options (see BEMOPTIONS)
      obj.p1 = p1;
      obj.p2 = p2;
      %  initialize Green function
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'compgreenstatlayer : ' );
      disp( struct( 'p1', obj.p1, 'p2', obj.p2,  ...
                    'g',  obj.g,  'gr', obj.gr, 'layer', obj.layer ) );
    end    
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
    
end
