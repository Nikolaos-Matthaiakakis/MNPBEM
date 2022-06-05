classdef dipoleretmirror < bembase
  %  Excitation of an oscillating dipole with mirror symmetry.
  %    Given a dipole oscillating with some frequency, DIPOLERET computes 
  %    the external potentials needed for BEM simulations and determines
  %    the total and radiative scattering rates for the dipole.

  %%  Properties
  properties (Constant)
    name = 'dipole'
    needs = { struct( 'sim', 'ret' ), 'sym' }
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
    function obj = dipoleretmirror( varargin )
      %  Initialize dipole excitation with mirror symmetry.
      %  
      %  Usage :
      %    obj = dipoleretmirror( pt, dip )
      %    obj = dipoleretmirror( pt, dip, medium, pinfty )
      %    obj = dipoleretmirror( pt, dip, 'full' ) 
      %    obj = dipoleretmirror( pt, dip, 'full', medium, pinfty )      
      %  Input
      %    pt   :  compound of points (or compoint) for dipole positions      
      %    dip  :  directions of dipole moments
      %    medium   :  embedding medium (1 on default)
      %    pinfty   :  unit sphere at infinity (for radiative rate)
      %   'full'    :  indicate that dipole moments are given at each position      
      obj.dip = dipoleret( varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'dipoleretmirror : ' );
      disp( struct( 'dip', obj.dip.dip, 'pt', obj.dip.pt, 'sym', obj.sym ) );
    end
    
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
