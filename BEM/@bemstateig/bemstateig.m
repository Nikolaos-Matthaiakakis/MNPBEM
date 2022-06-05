classdef bemstateig < bembase
  %  BEM solver for quasistatic approximation and eigenmode expansion.
  %    Given an external excitation, BEMSTATEIG computes the surface
  %    charges such that the boundary conditions of Maxwell's equations
  %    in the quasistatic approximation (using an eigenmode expansion) 
  %    are fulfilled.
  % 
  %    See, e.g. Garcia de Abajo and Howie, PRB  65, 115418 (2002);
  %                      Hohenester et al., PRL 103, 106801 (2009).

  %%  Properties  
  properties (Constant)
    name = 'bemsolver'
    needs = { struct( 'sim', 'stat' ), 'nev' }
  end
  
  properties
    p       %  composite particle (see comparticle)
    nev     %  number of eigenmodes
    ur      %  right eigenvectors of surface derivative of Green function
    ul      %  left eigenvectors
    ene     %  eigenvalues
    unit    %  inner product of right and left eigenvectors
    enei    %  light wavelength in vacuum
            %    to determine whether new computation of matrices    
  end
  
  properties (Access = private)
    g       %  Green function (needed in bemstateig/field)
    mat     %  - inv( Lambda + F ) computed from eigenmodes
  end
  
  %%  Methods
  methods   
    function obj = bemstateig( varargin )
      %  Initialize quasistatic BEM solver with eigenmode expansion.
      %
      %  Usage :
      %    obj = bemstateig( p,       op, PropertyName, PropertyValue, ... )
      %    obj = bemstateig( p, [],   op, PropertyName, PropertyValue, ... )
      %    obj = bemstateig( p, enei, op, PropertyName, PropertyValue, ... )
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
      disp( 'bemstateig : ' );
      disp( struct( 'p', obj.p, 'nev', obj.nev,  ...
                 'ur', obj.ur, 'enei', obj.enei ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
