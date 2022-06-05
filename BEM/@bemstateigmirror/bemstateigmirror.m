classdef bemstateigmirror < bembase
  %  BEM solver for quasistatic approximation and eigenmode expansion using
  %    mirror symmetry.  Given an external excitation, BEMSTATEIGMIRROR
  %    computes the surface charges such that the boundary conditions of
  %    Maxwell's equations in the quasistatic approximation (using an
  %    eigenmode expansion) are fulfilled.

  %%  Properties 
  properties (Constant)
    name = 'bemsolver'
    needs = { struct( 'sim', 'stat' ), 'nev', 'sym' }
  end  

  properties
    p       %  composite particle (see comparticlemirror)
    nev     %  number of eigenmodes
    ur      %  right eigenvectors of surface derivative of Green function
    ul      %  left eigenvectors
    ene     %  eigenvalues
    unit    %  inner product of right and left eigenvectors
    enei    %  light wavelength in vacuum
            %    to determine whether new computation of matrices    
end
  
  properties (Access = private)
    g       %  Green function (needed in bemstateigmirror/field)
    mat     %  - inv( Lambda + F ) computed from eigenmodes
  end

%%  Methods
  methods
    function obj = bemstateigmirror( varargin )
      %  Initialize quasistatic BEM solver with eigenmodes and mirror symmetry.
      %
      %  Usage :
      %    obj = bemstateigmirror( p,       op, PropertyName, PropertyValue, ... )
      %    obj = bemstateigmirror( p, [],   op, PropertyName, PropertyValue, ... )
      %    obj = bemstateigmirror( p, enei, op, PropertyName, PropertyValue, ... )
      %  Input
      %    p    :  compound of particles (see comparticle)
      %    enei :  light wavelength in vacuum
      %    op   :  options 
      %              additional fields of the option array can be passed as
      %              pairs of PropertyName and Propertyvalue                  
      %  Input
      %    p    :  compound of particles with mirror symmetry
      %    enei :  light wavelength in vacuum
      %    op   :  option array with number of eigenvalues and symmetry
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'bemstateigmirror : ' );
      disp( struct( 'p', obj.p, 'nev', obj.nev,  ...
           'ur', { obj.ur }, 'enei', { obj.enei } ) );

    end

  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
