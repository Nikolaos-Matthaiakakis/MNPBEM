classdef bemstatmirror < bembase
  %  BEM solver for quasistatic approximation with mirror symmetry.
  %    Given an external excitation, BEMSTATMIRROR computes the surface
  %    charges such that the boundary conditions of Maxwell's equations
  %    in the quasistatic approximation are fulfilled.

  %%  Properties
  properties (Constant)
    name = 'bemsolver'
    needs = { struct( 'sim', 'stat' ), 'sym' }
  end  
  
  properties
    p       %  composite particle (see comparticlemirror)
    F       %  surface derivative of Green function
    enei    %  light wavelength in vacuum
            %    to determine whether new computation of matrices     
  end
  
  properties (Access = private)
    g       %  Green function
    mat     %  - inv( Lambda + F )
  end

  %%  Methods
  methods
    function obj = bemstatmirror( varargin )
      %  Initialize quasistatic BEM solver.
      %
      %  Usage :
      %    obj = bemstatmirror( p,       op )
      %    obj = bemstatmirror( p, enei, op )
      %  Input
      %    p    :  compound of particles with mirror symmetry
      %    enei :  light wavelength in vacuum
      %    op   :  option structure with symmetry
      obj = init( obj, varargin{ : } ); 
    end
    
    function display( obj )
      %  Command window display.
      disp( 'bemstatmirror : ' );
      disp( struct( 'p', obj.p, 'F', { obj.F } ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
end
