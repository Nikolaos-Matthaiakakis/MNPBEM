classdef planewaveret < bembase
  %  Plane wave excitation for solution of full Maxwell equations.

  %%  Properties
  properties (Constant)
    name = 'planewave'
    needs = { struct( 'sim', 'ret' ) }
  end
  
  properties
    pol         %  light polarization
    dir         %  light propagation direction
    medium = 1  %  excitation through given medium (see potential, field)
  end
  
  properties (Access = private)
    spec        %  spectrum
  end
  
%%  Methods  
  methods 
    function obj = planewaveret( varargin )
      %  Initialize plane wave excitation.
      %  
      %  Usage :
      %    obj = planewaveret( pol, dir, medium )
      %    obj = planewaveret( pol, dir, medium, op, PropertyPair )
      %  Input
      %    pol      :  light polarization
      %    dir      :  light propagation direction
      %    op               :  options 
      %    PropertyName     :  additional properties
      %                          either OP or PropertyName can contain
      %                          fields 'medium' and 'pinfty' that select
      %                          the medium through which the particle is
      %                          excited or the unit sphere at infinity
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'planewaveret : ' );
      disp( struct( 'pol', obj.pol, 'dir', obj.dir, 'medium', obj.medium ) );
    end
    
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
