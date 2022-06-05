classdef spectrumstat < bembase
  %  Compute far fields and scattering cross sections in quasistatic limit.

  %%  Properties
  properties (Constant)
    name = 'spectrum'
    needs = { struct( 'sim', 'stat' ) }
  end  
  
  properties
    pinfty      %  discretized surface of unit sphere
    medium = 1  %  index of embedding medium
  end
  
  %%  Methods  
  methods 
    function obj = spectrumstat( varargin )
      %  Initialize spectrumret.
      %  
      %  Usage :
      %    obj = spectrumstat( pinfty, op, PropertyPair )
      %    obj = spectrumstat( dir,    op, PropertyPair )
      %    obj = spectrumstat(         op, PropertyPair )
      %  Input
      %    pinfty   :  discretized surface of unit sphere
      %    dir      :  light propagation directions
      %  PropertyName
      %    'medium' :  index of embedding medium
      obj = init( obj, varargin{ : } ); 
    end
    
    function display( obj )
      %  Command window display.
      disp( 'spectrumstat : ' );
      disp( struct( 'pinfty', obj.pinfty, 'medium', obj.medium ) );
    end    
  end
  
end
