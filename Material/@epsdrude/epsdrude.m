classdef epsdrude
  %  Drude dielectric function.
  %    eps = eps0 - wp ^ 2 / ( w * ( w + 1i * gammad ) ) 
  %
  %    Drude parameters are available for metals Au, Ag, Al.

  %%  Properties
  properties
    name        %  material name
    eps0 = 1    %  background dielectric constant
    wp          %  plasmon energy (eV)
    gammad      %  damping rate of plasmon (eV)
  end
  
  %%  Methods  
  methods   
    function obj = epsdrude( name )
      %  Constructor for Drude dielectric function.
      %
      %  Usage : 
      %    eps = epsdrude( name ), with name = { 'Au', 'Ag', 'Al' }
      %    eps = epsdrude
      if exist( 'name', 'var' )
        obj.name = name;
        obj = init( obj );
      end
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'epsdrude : ' );
      disp( struct( 'name', obj.name ) );
    end
   
  end
  
  methods (Access = private)
    obj = init( obj );
  end

end
