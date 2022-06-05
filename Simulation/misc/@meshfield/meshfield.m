classdef meshfield
  %  Compute electromagnetic fields for a grid of positions.

  %%  Properties
  properties
    x       %  x-positions for electromagnetic field
    y       %  y-positions for electromagnetic field
    z       %  z-positions for electromagnetic field
    p       %  particle
    nmax    %  work off calculation in portions of NMAX
  end
  
  properties
    pt      %  point object for [x,y,z]
    g       %  Green function connecting PT and P
    op      %  additional arguments to be passed to Green function  
  end
        
  %%  Methods  
  methods 
    function obj = meshfield( varargin )
      %  Initialize compound Green function object for layer structure.
      %  
      %  Usage :
      %    obj = meshfield( p, x, y, z,               varargin )
      %    obj = meshfield( p, x, y, z, 'nmax', nmax, varargin )
      %
      %  Input
      %    p        :  particle
      %    x        :  x-positions for electric field
      %    y        :  y-positions for electric field
      %    z        :  z-positions for electric field
      %    nmax     :  work off calculation in portions of NMAX
      %    varargin :  additional arguments to be passed to COMPOINT or
      %                to initialization of Green function
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'meshfield : ' );
      disp( struct( 'x', obj.x, 'y', obj.y, 'z', obj.z,  ...
                                            'p', obj.p, 'nmax', obj.nmax ) );
    end   
  end
 
  methods (Access = private)
    obj = init(   obj, varargin );
    varargout = field1( obj, varargin );
    varargout = field2( obj, varargin );
  end
end
