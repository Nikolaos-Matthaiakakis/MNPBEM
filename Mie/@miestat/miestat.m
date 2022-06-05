classdef miestat < bembase
  %  Mie theory for spherical particle using the quasistatic approximation.
  %    Programs are only intended for testing.

  %%  Properties
  properties (Constant)
    name = 'miesolver'
    needs = { struct( 'sim', 'stat' ) }
  end  
  
  properties
    epsin       %  dielectric function  inside of sphere
    epsout      %  dielectric function outside of sphere    
    diameter    %  sphere diameter
  end
  
  properties (Access = private)
    ltab        %  table of spherical harmonic degrees    
    mtab        %  table of spherical harmonic orders
  end
  
  %%  Methods  
  methods 
    function obj = miestat( varargin )
      %  Initialize spherical particle for quasistatic Mie theory.
      %  
      %  Usage :
      %    obj = miestat( epsin, epsout, diameter )
      %    obj = miestat( epsin, epsout, diameter, op, PropertyPair )      
      %  Input
      %    epsin    :  dielectric functions  inside of sphere
      %    epsout   :  dielectric functions outside of sphere      
      %    diameter :  sphere diameter
      %    op       :  options
      %    PropertyName     :  additional properties
      %                          either OP or PropertyName can contain a
      %                          field 'lmax' that determines the maximum
      %                          number for spherical harmonic degrees
      obj = init( obj, varargin{ : } );     
    end
    
    function display( obj )
      %  Command window display.
      disp( 'miestat : ' );
      disp( struct( 'epsin', obj.epsin, 'epsout', obj.epsout,  ...
                                        'diameter', obj.diameter ) );
    end    
  end
  
end
