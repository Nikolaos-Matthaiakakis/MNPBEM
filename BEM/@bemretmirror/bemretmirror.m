classdef bemretmirror < bembase
  %  BEM solver for full Maxwell equations with mirror symmetry.
  %    Given an external excitation, BEMRETMIRROR computes the surface
  %    charges such that the boundary conditions of Maxwell's equations
  %    are fulfilled.
  % 
  %    See, e.g. Garcia de Abajo and Howie, PRB  65, 115418 (2002).
  
  %%  Properties 
  properties (Constant)
    name = 'bemsolver'
    needs = { struct( 'sim', 'ret' ), 'sym' }
  end

  properties
    p           %  compound of discretized particles with mirror symmetry
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
    Sigma2      %  H2 * G2i, Eq. (21)
    Deltai      %  inv( Sigma1 - Sigma2 )
    Sigmai      %  Eq. (21,22)
  end
  
  %%  Methods
  methods
    
    function obj = bemretmirror( varargin )
      %  Initialize BEM solver with mirror symmetry.
      %
      %  Usage :
      %    obj = bemretmirror( p,       op, PropertyName, PropertyValue, ... )
      %    obj = bemretmirror( p, [],   op, PropertyName, PropertyValue, ... )
      %    obj = bemretmirror( p, enei, op, PropertyName, PropertyValue, ... )
      %  Input
      %    p    :  compound of particles (see comparticle)
      %    enei :  light wavelength in vacuum
      %    op   :  options 
      %              additional fields of the option array can be passed as
      %              pairs of PropertyName and Propertyvalue            
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'bemretmirror : ' );
      disp( struct( 'p', obj.p, 'g', obj.g ) );
    end
  end
    
end
