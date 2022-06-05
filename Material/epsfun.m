classdef epsfun 
  %  Dielectric function using user-supplied function.
  
  %%  Properties
  properties
    fun           %  function for evalualtion of dielectric function
    key = 'nm'    %  wavelengths (nm) or energies (eV)
  end
  
  %%  Methods  
  methods   
    function obj = epsfun( fun, key )
      %  Constructor for EPSFUN.
      %
      %  Usage : 
      %    obj = epsbase( fun )
      %    obj = epsbase( fun, key )
      %  Input
      %    fun    :  function for evaluation eps = fun( enei )
      %    key    :  wavelengths (nm) or energies (eV)
      obj.fun = fun;
      if exist( 'key', 'var' ),  obj.key = key;  end
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'nonlocal.epsfun : ' );
      disp( struct( 'fun', obj.fun, 'key', obj.key ) );
    end
    
    function varargout = subsref( obj, s )
      %  Evaluate dielectric function.
      %
      %  Usage for obj = nonlocal.epsfun :
      %    [ eps, k ] = obj( enei )
      %  Input
      %    enei   :  light wavelength in vacuum (nm)
      %  Output
      %    eps    :  Drude dielectric function
      %    k      :  wavenumber in medium
      switch s( 1 ).type
        case '.'
          [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );  
        case '()'
          %  light wavelength in vacuum
          enei = s( 1 ).subs{ 1 };
          %  evaluate dielectric function
          switch obj.key
            case 'nm'
              eps = obj.fun( enei );
            case 'eV'
              units;
              eps = obj.fun( eV2nm ./ enei );
          end
          %  wavenumber
          k = 2 * pi ./ enei .* sqrt( eps );
          %  assign output
          [ varargout{ 1 : 2 } ] = deal( eps, k );
      end
    end
  end
  
end
