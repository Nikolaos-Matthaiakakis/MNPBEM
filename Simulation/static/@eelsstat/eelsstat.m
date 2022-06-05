classdef eelsstat < bembase & eelsbase
  %  Excitation of an electron beam with a high kinetic energy.
  %    Given an electron beam, EELSSTAT computes the external potentials
  %    needed for BEM simulations in the quasistatic limit and determines
  %    the energy loss probability for the electrons.
  %
  %    See Garcia de Abajo et al., PRB 65, 115418 (2002), RMP 82, 209 (2010).

  properties (Constant)
    name = 'eels'
    needs = { struct( 'sim', 'stat' ) }
  end
        
  %%  Methods  
  methods 
    function obj = eelsstat( varargin )
      %  Initialize electron beam excitation.
      %  
      %  Usage :
      %    obj = eelsstat( p, impact, width, vel, op, PropertyPair )
      %  Input
      %    p        :  particle object for EELS measurement      
      %    impact   :  impact parameter of electron beam
      %    width    :  width of electron beam for potential smearing
      %    vel      :  electron velocity in units of speed of light   
      %    op       :  option structre
      %  PropertyName
      %    'cutoff'   :  distance for integration refinement  
      %    'phiout'   :  half aperture collection angle of spectrometer 
      obj = obj@eelsbase( varargin{ : } );
    end

    function display( obj )
      %  Command window display.
      disp( 'eelsstat : ' );
      disp( struct( 'p', obj.p,  'impact', obj.impact,  ...
                                  'width', obj.width, 'vel', obj.vel ) );
    end
    
  end
    
end
