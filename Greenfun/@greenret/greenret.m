classdef greenret
  %  Green functions for solution of full Maxwell equations. 
  
%%  Properties
  properties
    p1      %  Green function between points p1 and comparticle p2
    p2      %  Green function between points p1 and comparticle p2
    op      %  options for calculation of Green function (see BEMOPTIONS)
  end
  
  properties %(Access = private)
    deriv = 'cart'  
            %  'cart' Green function derivative wrt Cartesian coordinates,
            %  'norm' only surface derivative
    order   %  order for expansion of exp( 1i * k * r )
    ind     %  index to face elements with refinement
    g       %  refined elements for Green function
    f       %  refined elements for derivative of Green function
  end
 
%%  Methods  
  methods 
    function obj = greenret( varargin )
      %  Initialize Green function for solution of full Maxwell equations.
      %  
      %  Usage :
      %    obj = greenret( p1, p2 )
      %    obj = greenret( p1, p2, op )
      %  Input
      %    p1   :  Green function between points p1 and comparticle p2
      %    p2   :  Green function between points p1 and comparticle p2
      %    op   :  options (see BEMOPTIONS)
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'greenret : ' );
      disp( struct( 'p1', obj.p1, 'p2', obj.p2, 'op', obj.op ) );
    end       
  end
    
end
