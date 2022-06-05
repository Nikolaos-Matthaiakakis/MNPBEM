classdef dipolestat < bembase
  %  Excitation of an oscillating dipole in quasistatic approximation.
  %    Given a dipole oscillating with some frequency, DIPOLESTAT computes 
  %    the external potentials needed for BEM simulations and determines
  %    the total and radiative scattering rates for the dipole.

  %%  Properties
  properties (Constant)
    name = 'dipole'
    needs = { struct( 'sim', 'stat' ) }
  end
  
  properties
    pt          %  compound of points (or compoint) for dipole positions
    dip         %  dipole moments
    varargin    %  additional arguments to be passed to COMPGREENSTAT
  end
  
  %%  Methods  
  methods 
    function obj = dipolestat( pt, varargin )
      %  Initialize dipole excitation.
      %  
      %  Usage :
      %    obj = dipolestat( pt, dip, op, PropertyPair )
      %    obj = dipolestat( pt, dip, 'full', op, PropertyPair )
      %  Input
      %    pt          :  compound of points (or compoint) for dipole positions      
      %    dip         :  directions of dipole moments
      %    op          :  option structure
      %   'full'       :  indicate that dipole moments are given at each position
      %  PropertyPair  :  additional arguments to be passed to COMPGREENSTAT
      obj.pt  = pt;
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'dipolestat : ' );
      disp( struct( 'dip', obj.dip, 'pt', obj.pt ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
