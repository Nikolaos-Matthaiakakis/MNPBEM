function obj = init( obj, varargin )
%  INIT - Set properties of COMPARTICLE object.
%
%  Usage for obj = comparticle :
%    obj = comparticle( obj, varargin )
%  Input
%    varargin :  arguments passed to closed

%  index for closed surfaces (used in COMPGREEN)
obj.closed = cell( size( obj.p ) );
%  handle closed arguments
if ~isempty( varargin ),  obj = closed( obj, varargin{ : } );  end
