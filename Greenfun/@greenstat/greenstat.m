classdef greenstat
  %  Green functions for quasistatic approximation. 
  
%%  Properties
  properties
    p1      %  Green function between points p1 and comparticle p2
    p2      %  Green function between points p1 and comparticle p2
    op      %  options for calculation of Green function
  end
  
  properties (Access = private)
    deriv = 'cart'  
            %  'cart' Green function derivative wrt cartesian coordinates,
            %  'norm' only surface derivative
    ind     %  index to face elements with refinement
    g       %  refined elements for Green function
    f       %  refined elements for derivative of Green function
  end
 
%%  Methods  
  methods 
    function obj = greenstat( p1, p2, varargin )
      %  Initialize Green function in quasistatic approximation.
      %  
      %  Usage :
      %    obj = greenstat( p1, p2 )
      %    obj = greenstat( p1, p2, op )
      %  Input
      %    p1   :  Green function between points p1 and comparticle p2
      %    p2   :  Green function between points p1 and comparticle p2
      %    op   :  options
      obj.p1 = p1;
      obj.p2 = p2;
      %  initialize Green function
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'greenstat : ' );
      disp( struct( 'p1', obj.p1, 'p2', obj.p2, 'op', obj.op ) );
    end    
  end
  
end
