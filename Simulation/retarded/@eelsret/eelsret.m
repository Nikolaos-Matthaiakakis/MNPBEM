classdef eelsret < bembase & eelsbase
  %  Excitation of an electron beam with a high kinetic energy.
  %    Given an electron beam, EELSRET computes the external potentials
  %    needed for BEM simulations and determines the energy loss
  %    probability for the electrons.
  %
  %    See Garcia de Abajo et al., PRB 65, 115418 (2002), RMP 82, 209 (2010).

  properties (Constant)
    name = 'eels'
    needs = { struct( 'sim', 'ret' ) }
  end
  
  properties (Access = private)
    spec        %  spectrum
  end        
  %%  Methods  
  methods 
    function obj = eelsret( varargin )
      %  Initialize electron beam excitation.
      %  
      %  Usage :
      %    obj = eelsret( p, impact, width, vel, op, PropertyPairs )
      %  Input
      %    p        :  particle object for EELS measurement      
      %    impact   :  impact parameter of electron beam
      %    width    :  width of electron beam for potential smearing
      %    vel      :  electron velocity in units of speed of light   
      %    op       :  option structure
      %  PropertyName
      %    'cutoff'   :  distance for integration refinement  
      %    'phiout'   :  half aperture collection angle of spectrometer
      %    'pinfty'   :  sphere at infinity for photon loss probability
      %    'medium'   :  index of embedding medium
      
      obj = obj@eelsbase( varargin{ : } );
      %  initialize sphere at infinity for photon loss probability
      obj = init( obj, varargin{ 5 : end } );
    end

    function display( obj )
      %  Command window display.
      disp( 'eelsret : ' );
      disp( struct( 'p', obj.p,  'impact', obj.impact,  ...
                                  'width', obj.width, 'vel', obj.vel ) );
    end    
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
    
end
