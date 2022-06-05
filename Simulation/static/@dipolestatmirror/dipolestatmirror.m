classdef dipolestatmirror < bembase
  %  Excitation of an oscillating dipole in quasistatic approximation and
  %    using mirror symmetry of the particles.  Given a dipole oscillating
  %    with some frequency, DIPOLESTATMIRROR computes the external
  %    potentials needed for BEM simulations and determines the total and
  %    radiative scattering rates for the dipole.

  %%  Properties 
  properties (Constant)
    name = 'dipole'
    needs = { struct( 'sim', 'stat' ), 'sym' }
  end  
  
  properties
    dip         %  dipole
    sym         %  symmetry value (set in subsref > potential)
  end

  properties (Access = private)
    mirror      %  mirror dipoles for internal use
  end
  
%%  Methods  
  methods 
    function obj = dipolestatmirror( varargin )
      %  Initialize dipole excitation with mirror symmetry.
      %  
      %  Usage :
      %    obj = dipolestatmirror( pt, dip )
      %    obj = dipolestatmirror( pt, dip, 'full' )
      %  Input
      %    pt   :  compound of points (or compoint) for dipole positions      
      %    dip  :  directions of dipole moments
      %   'full'    :  indicate that dipole moments are given at each position
      obj.dip = dipolestat( varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'dipolestatmirror : ' );
      disp( struct( 'dip', obj.dip.dip, 'pt', obj.dip.pt, 'sym', obj.sym ) );
    end
    
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
