classdef miegans
  %  Mie-Gans theory for ellipsoidal particle and quasistatic approximation.
  %    Programs are only intended for testing.

%%  Properties
  properties
    epsin       %  dielectric function  inside of ellipsoid
    epsout      %  dielectric function outside of ellipsoid 
    ax          %  ellipsoid axes
  end
  
  properties (Access = private)
    L1          %  depolarization factors, van de Hulst, Sec. 6.32
    L2
    L3
  end
  
%%  Methods  
  methods 
    function obj = miegans( epsin, epsout, ax )
      %  Initialize ellisposidal particle for quasistatic Mie-Gans theory.
      %  
      %  Usage :
      %    obj = miegans( epsin, epsout, ax )
      %  Input
      %    epsin    :  dielectric functions  inside of ellipsoid
      %    epsout   :  dielectric functions outside of ellipsoid   
      %    ax       :  ellisoid axes
      obj.epsin  = epsin;
      obj.epsout = epsout;
      obj.ax     = ax;
      %  compute depolarization factors
      obj = init( obj );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'miegans : ' );
      disp( struct( 'epsin', obj.epsin, 'epsout', obj.epsout,  ...
                                            'ax', obj.ax ) );
    end
    
  end
  
  methods (Access = private)
    obj = init( obj );
  end
  
end
