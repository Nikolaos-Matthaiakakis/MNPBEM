classdef spectrumretlayer < bembase
  %  Compute far fields and scattering cross sections for layer structure.

  %%  Properties
  properties (Constant)
    name = 'spectrum'
    needs = { struct( 'sim', 'ret' ), 'layer' }
  end  
    
  properties
    pinfty      %  discretized surface of unit sphere
    layer       %  layer structure
    medium = [] %  specify medium (of upper or lower layer) for spectrum
  end
  
  %%  Methods  
  methods 
    function obj = spectrumretlayer( varargin )
      %  Initialize spectrumretlayer.
      %  
      %    obj = spectrumretlayer( pinfty, op, PropertyPair )
      %    obj = spectrumretlayer( dir,    op, PropertyPair )
      %    obj = spectrumretlayer(         op, PropertyPair )
      %  Input
      %    pinfty   :  discretized surface of unit sphere
      %    dir      :  light propagation directions
      %  PropertyName
      %    'medium' :  index of embedding medium
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'spectrumretlayer : ' );
      disp( struct( 'layer', obj.layer, 'pinfty', obj.pinfty ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
