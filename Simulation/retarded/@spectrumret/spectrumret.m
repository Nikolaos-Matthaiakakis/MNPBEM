classdef spectrumret < bembase
  %  Compute far fields and scattering cross sections.

  %%  Properties
  properties (Constant)
    name = 'spectrum'
    needs = { struct( 'sim', 'ret' ) }
  end  
  
  properties
    pinfty      %  discretized surface of unit sphere
    medium = 1  %  index of embedding medium
  end
  
  %%  Methods  
  methods 
    function obj = spectrumret( varargin )
      %  Initialize spectrumret.
      %  
      %  Usage :
      %    obj = spectrumret( pinfty, op, PropertyPair )
      %    obj = spectrumret( dir,    op, PropertyPair )
      %    obj = spectrumret(         op, PropertyPair )
      %  Input
      %    pinfty   :  discretized surface of unit sphere
      %    dir      :  light propagation directions
      %  PropertyName
      %    'medium' :  index of embedding medium
      obj = init( obj, varargin{ : } ); 
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'spectrumret : ' );
      disp( struct( 'pinfty', obj.pinfty, 'medium', obj.medium ) );
    end    
  end
  
end
