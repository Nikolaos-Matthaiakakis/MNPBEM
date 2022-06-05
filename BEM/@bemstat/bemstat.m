classdef bemstat < bembase
  %  BEM solver for quasistatic approximation.
  %    Given an external excitation, BEMSTAT computes the surface
  %    charges such that the boundary conditions of Maxwell's equations
  %    in the quasistatic approximation are fulfilled.
  % 
  %    See, e.g. Garcia de Abajo and Howie, PRB  65, 115418 (2002);
  %                      Hohenester et al., PRL 103, 106801 (2009).

  %%  Properties
  properties (Constant)
    name = 'bemsolver'
    needs = { struct( 'sim', 'stat' ) }
  end

  properties
    p       %  composite particle (see comparticle)
    F       %  surface derivative of Green function
    enei    %  light wavelength in vacuum
            %    to determine whether new computation of matrices     
  end
  
  properties (Access = private)
    g       %  Green function (needed in bemstat/field)
    mat     %  - inv( Lambda + F )
  end
  
  %%  Methods
  methods  
    function obj = bemstat( varargin )
      %  Initialize quasistatic BEM solver.
      %
      %  Usage :
      %    obj = bemstat( p,       op, PropertyName, PropertyValue, ... )
      %    obj = bemstat( p, [],   op, PropertyName, PropertyValue, ... )
      %    obj = bemstat( p, enei, op, PropertyName, PropertyValue, ... )
      %  Input
      %    p    :  compound of particles (see comparticle)
      %    enei :  light wavelength in vacuum
      %    op   :  options 
      %              additional fields of the option array can be passed as
      %              pairs of PropertyName and Propertyvalue
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'bemstat : ' );
      disp( struct( 'p', obj.p, 'F', obj.F ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
