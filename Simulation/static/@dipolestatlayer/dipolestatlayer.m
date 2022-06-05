classdef dipolestatlayer < bembase
  %  Excitation of an oscillating dipole in quasistatic approximation.
  %    Given a dipole oscillating with some frequency, DIPOLESTATLAYER
  %    computes the external potentials needed for BEM simulations and
  %    determines the total and radiative scattering rates for the dipole
  %    inside a layer structure.

  %%  Properties
  properties (Constant)
    name = 'dipole'
    needs = { struct( 'sim', 'stat' ), 'layer' }
  end
  
  properties
    dip         %  dipoles located above substrate
    idip        %  image dipoles
    layer       %  layer structure
    spec        %  spectrum
  end
  
  properties (Access = private)
    varargin    %  additional arguments to be passed to COMPGREENSTATLAYER    
  end
    
  %%  Methods  
  methods 
    function obj = dipolestatlayer( varargin )
      %  Initialize dipole excitation for layer structure.
      %  
      %  Usage :
      %    obj = dipolestatlayer( pt, dip, op, PropertyPair )
      %    obj = dipolestatlayer( pt, dip, 'full', op, PropertyPair )
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
      disp( 'dipolestatlayer : ' );
      disp( struct( 'dip', obj.dip.dip, 'pt', obj.dip.pt, 'layer', obj.layer ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
