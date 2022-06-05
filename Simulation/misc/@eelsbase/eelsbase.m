classdef eelsbase
  %  Base class for electron energy loss spectroscopy (EELS) simulations.
  %    The electron beam is assumed to propagate along z with velocity vel.
  %    EELSBASE provides the base functions for EELSSTAT and EELSRET.
  %
  %    See Garcia de Abajo et al., PRB 65, 115418 (2002), RMP 82, 209 (2010).
  
%%  Properties
  properties
    p             %  particle object for EELS simulation    
    impact        %  impact parameters of electron beams
    width         %  width of electron beam for potential smearing
    vel           %  electron velocity in units of speed of light  
    phiout = 1e-2 %  half aperture collection angle of spectrometer, Eq. (19)
  end
  
  properties (Access = protected)
    z           %  z values of intersection points
    indimp      %  relate z values to impact parameters
    indmat      %  relate z values to material index
    indquad     %  index to surface elements to be refined
  end
        
%%  Methods  
  methods 
    function obj = eelsbase( varargin )
      %  Initialize electron beam excitation.
      %  
      %  Usage :
      %    obj = eelsbase( p, impact, width, vel, op, PropertyPairs )
      %  Input
      %    p        :  particle object for EELS measurement      
      %    impact   :  impact parameter of electron beam
      %    width    :  width of electron beam for potential smearing
      %    vel      :  electron velocity in units of speed of light   
      %  PropertyName
      %    'cutoff'   :  distance for integration refinement  
      %    'phiout'   :  half aperture collection angle of spectrometer
      obj = init( obj, varargin{ : } );
    end

    function display( obj )
      %  Command window display.
      disp( 'eelsbase : ' );
      disp( struct( 'p', obj.p,  'impact', obj.impact,   ...
             'width', obj.width, 'vel', obj.vel, 'phiout', obj.phiout ) );
    end    
  end

  
  methods (Static)
    function vel = ene2vel( ene )
      %  Convert kinetic electron energy in eV to velocity in
      %  units of speed of light.
      %
      %  Usage :
      %    vel = eelsret.ene2vel( ene )
      %  Input
      %    ene      :  electron energy in eV
      %  Output
      %    vel      :  electron velocity in units of speed of light
      vel = sqrt( 1 - 1 ./ ( 1 + ene / 0.51e6 ) .^ 2 );
    end
  end
  
end
