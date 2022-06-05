classdef planewaveretmirror < bembase
  %  Plane wave excitation for solution of full Maxwell equations using
  %    mirror symmetry.

  %%  Properties
  properties (Constant)
    name = 'planewave'
    needs = { struct( 'sim', 'ret' ), 'sym' }
  end

  properties
    pol         %  light polarization
    dir         %  light propagation direction
  end
  
  properties (Access = private)
    exc         %  plane wave excitation
  end
    
%%  Methods  
  methods 
    function obj = planewaveretmirror( pol, dir, varargin )
      %  Initialize plane wave excitation.
      %  
      %  Usage :
      %    obj = planewaveretmirror( pol, dir )
      %    obj = planewaveretmirror( pol, dir, medium, pinfty )
      %  Input
      %    pol      :  light polarization
      %    dir      :  light propagation direction
      %    medium   :  plane wave excitation through given media
      %                  on default medium = 1
      %    pinfty   :  unit sphere at infinity
      assert( all( pol( :, 3 ) ) == 0 );
      
      obj.pol = pol;
      obj.dir = dir;
      obj.exc = planewaveret( pol, dir, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'planewaveretmirror : ' );
      disp( struct( 'pol', obj.pol, 'dir', obj.dir ) );
    end
    
  end
  
end
