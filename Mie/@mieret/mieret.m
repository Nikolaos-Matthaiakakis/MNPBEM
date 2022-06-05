classdef mieret < bembase
  %  Mie theory for spherical particle using the full Maxwell equations.
  %    Programs are only intended for testing.

  %%  Properties
  properties (Constant)
    name = 'miesolver'
    needs = { struct( 'sim', 'ret' ) }
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
    function obj = mieret( varargin )
      %  Initialize spherical particle for full Mie theory.
      %  
      %  Usage :
      %    obj = mieret( epsin, epsout, diameter )
      %    obj = mieret( epsin, epsout, diameter, op, PropertyPair )      
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
      disp( 'mieret : ' );
      disp( struct( 'epsin', obj.epsin, 'epsout', obj.epsout,  ...
                                        'diameter', obj.diameter ) );
    end
    
  end
  
end
