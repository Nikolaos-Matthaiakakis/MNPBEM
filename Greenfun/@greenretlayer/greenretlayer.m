classdef greenretlayer
  %  Green function for reflected part of layer structure.

  %%  Properties
  properties
    p1      %  Green function between points p1 and particle p2
    p2      %  Green function between points p1 and particle p2
    layer   %  layer structure
  end
  
  properties 
    deriv = 'cart'  
            %  'cart' Green function derivative wrt Cartesian coordinates,
            %  'norm' only surface derivative    
    enei    %  wavelength for previously computed reflected Green functions            
    tab     %  table for reflected Green functions
    G       %  reflected Green function
    F       %  surface derivative of G
    Gp      %  derivative of reflected Green function
  end
  
  properties (Access = private)
    ind     %  index to elements with refinement    
    id      %  index to diagonal elements
    ir      %  radii for refined Green function elements
    iz      %  z-values for refined Green function elements
    ig      %  refined Green function elements
    ifr     %  refined derivative of Green function in radial direction
    if1     %  refined derivative of Green function in x-direction
    if2     %  refined derivative of Green function in y-direction
    ifz     %  refined derivative of Green function in z-direction
  end
  
  %%  Methods  
  methods 
    function obj = greenretlayer( p1, p2, varargin )
      %  Initialize Green function object for layer structure.
      %  
      %  Usage :
      %    obj = greenretlayer( p1, p2, op )
      %    obj = greenretlayer( p1, p2, op, PropertyPair )      
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
      disp( 'greenretlayer : ' );
      disp( struct( 'p1', obj.p1, 'p2', obj.p2, 'layer', obj.layer ) );
    end
  end
  
end
