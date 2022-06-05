classdef epsconst
  %  Dielectric constant.
  
  %%  Properties
  properties
    eps         %  value of dielectric constant
  end
  
  %%  Methods
  methods
    function obj = epsconst( eps )
      %  Set dielectric constant to given value.
      %
      %  Usage :
      %    eps = epsconst( 1.33 ^ 2 )
      obj.eps = eps;
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'epsconst : ' );
      disp( obj.eps );
    end  
    
    function k = wavenumber( obj, enei )
      %  Gives wavenumber in medium.
      %
      %  Usage for obj = epsconst
      %    k = obj.wavenumber( enei )
      %  Input
      %    enei  :  light wavelength in vacuum
      %  Output
      %    k     :  wavenumber in medium
      k = 2 * pi ./ enei .* sqrt( obj.eps );    
    end
      
  end
  
end