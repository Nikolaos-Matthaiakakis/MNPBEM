classdef bemretiter < bembase & bemiter
  %  Iterative BEM solver for full Maxwell equations.
  %    Given an external excitation, BEMRETITER computes the surface
  %    charges iteratively such that the boundary conditions of Maxwell's
  %    equations are fulfilled.
  % 
  %    See, e.g. Garcia de Abajo and Howie, PRB  65, 115418 (2002).
  
  %%  Properties 
  properties (Constant)
    name = 'bemsolver'
    needs = { struct( 'sim', 'ret' ), 'iter' }
  end
  
  properties
    p           %  compound of discretized particles
    g           %  Green function
    enei = []   %  light wavelength in vacuum
                %    to determine whether new computation of matrices                 
  end
      
  properties (Access = private)
    op          %  option structure
    sav         %  variables for evaluation of preconditioner
    k           %  wavenumber of light in vacuum
    eps1        %  dielectric function at particle inside
    eps2        %  dielectric function at particle outside
    nvec        %  outer surface normal
    G1, H1      %  Green function and surface derivative inside  particle
    G2, H2      %  Green function and surface derivative outside particle
  end
  
  %%  Methods
  methods
    function obj = bemretiter( varargin )
      %  Initialize BEM solver.
      %
      %  Usage :
      %    obj = bemretiter( p,       op, PropertyName, PropertyValue, ... )
      %    obj = bemretiter( p, [],   op, PropertyName, PropertyValue, ... )
      %    obj = bemretiter( p, enei, op, PropertyName, PropertyValue, ... )
      %  Input
      %    p    :  compound of particles (see comparticle)
      %    enei :  light wavelength in vacuum
      %    op   :  options 
      %              additional fields of the option array can be passed as
      %              pairs of PropertyName and Propertyvalue 
      obj = obj@bemiter( varargin{ 2 : end } );
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'bemretiter : ' );
      disp( struct( 'p', obj.p, 'g', obj.g,  ...
                           'solver', obj.solver, 'tol', obj.tol ) );
    end
  end
    
end
