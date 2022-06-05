classdef compound
  %  Compound of points or particles within a dielectric environment.
  %    Base class for composite particles and points.
  
  %%  Properties
  properties
    eps         %  cell array of dielectric functions
    p           %  cell array of points or particles
    inout       %  medium where points are embedded (n x 2 for particles)
    mask        %  mask for points or particles    
  end  
  
  properties (Access = protected)
    pc          %  compound of points or particles
  end
  
  %%  Methods
  methods
    function obj = compound( eps, p, inout )
      %  Set properties of compound.
      %
      %  Usage :
      %    obj = compound( eps, p, inout )
      %  Input
      %    eps      :  cell array of dielectric functions
      %    p        :  cell array of points or particles
      %    inout    :  index to medium eps
      %                  n x 2 array for particles, with index to
      %                  medium in- and outside of interface
      
      [ obj.eps, obj.p, obj.inout ] = deal( eps, p, inout );
      %  mask and compound of particles/points
      [ obj.mask, obj.pc ]  = deal( 1 : length( p ), vertcat( p{ : } ) );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'compoint : ' );
      disp(  ...
        struct( 'eps', { obj.eps }, 'p', { obj.p },  ...
                'inout', obj.inout, 'mask', obj.mask ) );
    end 
        
  end
  
  methods (Access = private)
    full = expand( obj, val );
  end
end
