classdef bemstatlayer < bembase
  %  BEM solver for quasistatic approximation and layer structure.
  %    Given an external excitation, BEMSTATLAYER computes the surface
  %    charges such that the boundary conditions of Maxwell's equations
  %    in the quasistatic approximation are fulfilled.
  
  %%  Properties
  properties (Constant)
    name = 'bemsolver'
    needs = { struct( 'sim', 'stat' ), 'layer' }
  end

  properties
    p       %  composite particle 
    g       %  Green function object
    enei    %  light wavelength in vacuum
            %    to determine whether new computation of matrices    
  end
  
  properties (Access = private)
    mat     %  matrix for solution of BEM equations
  end
  
  %%  Methods
  methods  
    function obj = bemstatlayer( varargin )
      %  Initialize quasistatic BEM solver for layer structure.
      %
      %  Usage :
      %    obj = bemstatlayer( p,       op, PropertyName, PropertyValue, ... )
      %    obj = bemstatlayer( p, [],   op, PropertyName, PropertyValue, ... )
      %    obj = bemstatlayer( p, enei, op, PropertyName, PropertyValue, ... )
      %  Input
      %    p    :  compound of particles 
      %    enei :  light wavelength in vacuum
      %    op   :  options 
      %              additional fields of the option array can be passed as
      %              pairs of PropertyName and Propertyvalue
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'bemstatlayer : ' );
      disp( struct( 'p', obj.p, 'g', obj.g ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
