classdef bemret < bembase
  %  BEM solver for full Maxwell equations.
  %    Given an external excitation, BEMRET computes the surface
  %    charges such that the boundary conditions of Maxwell's equations
  %    are fulfilled.
  % 
  %    See, e.g. Garcia de Abajo and Howie, PRB  65, 115418 (2002).
  
  %%  Properties 
  properties (Constant)
    name = 'bemsolver'
    needs = { struct( 'sim', 'ret' ) }
  end
  
  properties
    p           %  compound of discretized particles
    g           %  Green function
    enei = []   %  light wavelength in vacuum
                %    to determine whether new computation of matrices 
  end
  
  properties (Access = private)
    k           %  wavenumber of light in vacuum
    nvec        %  outer surface normals of discretized surface
    eps1        %  dielectric function  inside of surface
    eps2        %  dielectric function outside of surface
    G1i         %  inverse of  inside Green function G1
    G2i         %  inverse of outside Green function G2
    L1          %  G1 * eps1 * G1i, Eq. (22)
    L2          %  G2 * eps2 * G2i
    Sigma1      %  H1 * G1i, Eq. (21)
    Deltai      %  inv( Sigma1 - Sigma2 ) 
    Sigmai      %  Eq. (21,22)
  end
  
  %%  Methods
  methods
    function obj = bemret( varargin )
      %  Initialize BEM solver.
      %
      %  Usage :
      %    obj = bemret( p,       op, PropertyName, PropertyValue, ... )
      %    obj = bemret( p, [],   op, PropertyName, PropertyValue, ... )
      %    obj = bemret( p, enei, op, PropertyName, PropertyValue, ... )
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
      disp( 'bemret : ' );
      disp( struct( 'p', obj.p, 'g', obj.g ) );
    end
  end
    
end
