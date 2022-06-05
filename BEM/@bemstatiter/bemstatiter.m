classdef bemstatiter < bembase & bemiter
  %  Iterative BEM solver for quasistatic approximation.
  %    Given an external excitation, BEMSTAT computes the surface
  %    charges such that the boundary conditions of Maxwell's equations
  %    in the quasistatic approximation are fulfilled.  Maxwell's equations
  %    are solved iteratively.
  % 
  %    See, e.g. Garcia de Abajo and Howie, PRB  65, 115418 (2002);
  %                      Hohenester et al., PRL 103, 106801 (2009).

  %%  Properties
  properties (Constant)
    name = 'bemsolver'
    needs = { struct( 'sim', 'stat' ), 'iter' }
  end

  properties
    p           %  composite particle (see COMPARTICLE)
    F           %  surface derivative of Green function
    enei        %  light wavelength in vacuum
                %    to determine whether new computation of matrices     
  end
  
  properties (Access = private)
    op          %  option structure
    g           %  Green function object
    lambda      %  resolvent matrix is - inv( lambda + F )
    mat         %  - inv( Lambda + F ) computed with H-matrix inversion
  end
  
  %%  Methods
  methods  
    function obj = bemstatiter( varargin )
      %  Initialize quasistatic, itertative BEM solver.
      %
      %  Usage :
      %    obj = bemstatiter( p,       op, PropertyPairs )
      %    obj = bemstatiter( p, [],   op, PropertyPairs )
      %    obj = bemstatiter( p, enei, op, PropertyPairs )
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
      disp( 'bemstatiter : ' );
      disp( struct( 'p', obj.p, 'F', obj.F,  ...
                           'solver', obj.solver, 'tol', obj.tol ) );
    end
  end
  
end
