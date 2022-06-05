classdef dipoleretlayer < bembase
  %  Excitation of an oscillating dipole.
  %    Given a dipole oscillating with some frequency, DIPOLERETLAYER
  %    computes the external potentials needed for BEM simulations and
  %    determines the total and radiative scattering rates for the dipole
  %    inside a layer structure.

  %%  Properties
  properties (Constant)
    name = 'dipole'
    needs = { struct( 'sim', 'ret' ), 'layer' }
  end
  
  properties
    dip         %  dipoles
    layer       %  layer structure
    spec        %  spectrum for calculation of radiative decay rate
  end
  
  properties (Access = private)
    tab         %  table for reflected Green functions
    varargin    %  additional arguments to be passed to COMPGREENRETLAYER    
  end
    
  %%  Methods  
  methods 
    function obj = dipoleretlayer( varargin )
      %  Initialize dipole excitation for layer structure.
      %  
      %  Usage :
      %    obj = dipoleretlayer( pt, dip, op, PropertyPair )
      %    obj = dipoleretlayer( pt, dip, 'full', op, PropertyPair )
      %  Input
      %    pt          :  compound of points (or compoint) for dipole positions      
      %    dip         :  directions of dipole moments
      %    op          :  option structure
      %   'full'       :  indicate that dipole moments are given at each position
      %  PropertyPair  :  additional arguments for boundary element integration
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'dipoleretlayer : ' );
      disp( struct( 'dip', obj.dip.dip, 'pt', obj.dip.pt, 'layer', obj.layer ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
