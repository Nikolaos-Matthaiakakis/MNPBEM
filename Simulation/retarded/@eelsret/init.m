function obj = init( obj, varargin )
%  INIT - Initialize sphere at infinity for photon loss probability.

%  extract options
op = getbemoptions( { 'eels', 'eelsret' }, varargin{ : } );

%  initialize SPECTRUMRET object
if isfield( op, 'pinfty' )
  obj.spec = spectrumret( op.pinfty, varargin{ : } );
else
  obj.spec = spectrumret( varargin{ : } );
end
