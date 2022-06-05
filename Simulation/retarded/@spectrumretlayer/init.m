function obj = init( obj, varargin )
%  INIT - Initialize SPECTRUMRETLAYER.
%  
%  Usage for obj = spectrumretlayer :
%    obj = init( obj, pinfty, op, PropertyPair )
%    obj = init( obj, dir,    op, PropertyPair )
%    obj = init( obj,         op, PropertyPair )
%  Input
%    pinfty   :  discretized surface of unit sphere
%    dir      :  light propagation directions
%  PropertyName
%    'medium' :  index of embedding medium

%  deal with different calling sequences
if isempty( varargin ) || ischar( varargin{ 1 } ) || isstruct( varargin{ 1 } )
  pinfty =  ...
    trispheresegment( linspace( 0, 2 * pi, 21 ), linspace( 0, pi, 21 ), 2 );
elseif isnumeric( varargin{ 1 } )
  [ pinfty, varargin ] =  ...
           deal( struct( 'nvec', varargin{ 1 } ), varargin( 2 : end ) );
else
  [ pinfty, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end

try
  %  upper and lower part of PINFTY
  [ up, lo ] = select( pinfty, 'index', find( pinfty.nvec( :, 3 ) >= 0 ) );
  %  bring faces of PINFTY into proper order
  obj.pinfty = [ up; lo ];
catch
  obj.pinfty = pinfty;
end

%  get options
op = getbemoptions( varargin{ : } );
%  extract layer
obj.layer = op.layer;
%  specify medium (of upper or lower layer) for spectrum
if isfield( op, 'medium' ) && ~isempty( op.medium )
  assert( op.medium == layer.ind( 1 ) || op.medium == layer.ind( end ) );
  %  save medium
  obj.medium = op.medium;
end