classdef dipoleret < bembase
  %  Excitation of an oscillating dipole.
  %    Given a dipole oscillating with some frequency, DIPOLERET computes 
  %    the external potentials needed for BEM simulations and determines
  %    the total and radiative scattering rates for the dipole.

  %%  Properties
  properties (Constant)
    name = 'dipole'
    needs = { struct( 'sim', 'ret' ) }
  end

  properties
    pt          %  compound of points (or compoint) for dipole positions
    dip         %  dipole moment  
    spec        %  spectrum for calculation of radiative decay rate
    
  end
  
  properties (Access = private)
    varargin    %  additional arguments to be passed to COMPGREENRET
  end
  
%%  Methods  
  methods 
    function obj = dipoleret( pt, varargin )
      %  Initialize dipole excitation.
      %  
      %  Usage :
      %    obj = dipoleret( pt, dip,         op, PropertyPair )
      %    obj = dipoleret( pt, dip, 'full', op, PropertyPair )      
      %  Input
      %    pt       :  compound of points (or compoint) for dipole positions      
      %    dip      :  directions of dipole moments
      %   'full'    :  indicate that dipole moments are given at each position 
      %  PropertyName
      %    medium   :  embedding medium (1 on default)
      %    pinfty   :  unit sphere at infinity (for radiative rate)
      %      additional arguments are passed to COMPGREENRET
      obj.pt  = pt;
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'dipoleret : ' );
      disp( struct( 'dip', obj.dip, 'pt', obj.pt ) );
    end
    
  end
  
  methods (Access = private)
    obj = init( obj, dip, key );
  end
  
end
