function obj = init( obj, varargin )
%  INIT - Initialize SPECTRUMSTAT.
%  
%  Usage for obj = spectrumstat :
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
  obj.pinfty = trisphere( 256, 2 );
elseif isnumeric( varargin{ 1 } )
  [ obj.pinfty, varargin ] =  ...
           deal( struct( 'nvec', varargin{ 1 } ), varargin( 2 : end ) );
else
  [ obj.pinfty, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end

%  get options
op = getbemoptions( varargin{ : } );
%  extract medium
if isfield( op, 'medium' ),  obj.medium = op.medium;  end
