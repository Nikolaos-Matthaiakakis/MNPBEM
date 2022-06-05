classdef spectrumstatlayer < bembase
  %  Compute far fields and scattering cross sections for layer structure.

  %%  Properties
  properties (Constant)
    name = 'spectrum'
    needs = { struct( 'sim', 'stat' ), 'layer' }
  end  
  
  properties
    pinfty      %  discretized surface of unit sphere
    layer       %  layer structure
    medium = [] %  specify medium (of upper or lower layer) for spectrum
  end
  
  %%  Methods  
  methods 
    function obj = spectrumstatlayer( varargin )
      %  Initialize spectrumstatlayer.
      %  
      %    obj = spectrumstatlayer( pinfty, op, PropertyPair )
      %    obj = spectrumstatlayer( dir,    op, PropertyPair )
      %    obj = spectrumstatlayer(         op, PropertyPair )
      %  Input
      %    pinfty   :  discretized surface of unit sphere
      %    dir      :  light propagation directions
      %  PropertyName
      %    'medium' :  index of embedding medium
      obj = init( obj, varargin{ : } );
    end
    
    function display( obj )
      %  Command window display.
      disp( 'spectrumstatlayer : ' );
      disp( struct( 'layer', obj.layer, 'pinfty', obj.pinfty ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
