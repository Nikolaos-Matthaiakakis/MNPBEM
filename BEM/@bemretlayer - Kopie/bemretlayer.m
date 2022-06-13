classdef bemretlayer < bembase
  %  BEM solver for full Maxwell equations and layer structure.
  %    Given an external excitation, BEMRETLAYER computes the surface
  %    charges such that the boundary conditions of Maxwell's equations
  %    are fulfilled.
  % 
  %    See, e.g. Garcia de Abajo and Howie, PRB  65, 115418 (2002).
  %              Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015).
  
  %%  Properties 
  properties (Constant)
    name = 'bemsolver'
    needs = { struct( 'sim', 'ret' ), 'layer' }
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
    npar        %  parallel component of outer surface normal
    eps1        %  dielectric function  inside of surface
    eps2        %  dielectric function outside of surface
    G1i         %  inverse of  inside Green function G1
    G2pi;       %  inverse of outside parallel Green function G2
    G2          %  outside Green function G2
    H2          %  outside surface derivative of Green function G2
    Sigma1      %  H1 * G1i, Eq. (21)
    Gamma       %  inv( Sigma1 - Sigma2 )
    m           %  response matrix for layer system
  end
  
  %%  Methods
  methods
    function obj = bemretlayer( varargin )
      %  Initialize BEM solver for layer system.
      %
      %  Usage :
      %    obj = bemretlayer( p,       op, PropertyName, PropertyValue, ... )
      %    obj = bemretlayer( p, [],   op, PropertyName, PropertyValue, ... )
      %    obj = bemretlayer( p, enei, op, PropertyName, PropertyValue, ... )
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
      disp( 'bemretlayer : ' );
      disp( struct( 'p', obj.p, 'g', obj.g ) );
    end
  end
    
end
