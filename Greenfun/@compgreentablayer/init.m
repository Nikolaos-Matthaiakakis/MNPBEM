function obj = init( obj, layer, varargin )
%  INIT - Initialize compound Green function object for layer structure.
%  
%  Usage for obj = compgreentablayer :
%    obj = init( layer, tab1, tab2, ... )
%  Input
%    layer    :  layer structure
%    tab      :  grids for tabulated r and z-values

%  handle case where TAB is a vector
if numel( varargin{ 1 } ) ~= 1
  varargin = arrayfun( @( x ) x, varargin{ 1 }, 'UniformOutput', false );
end
%  save layer structure and allocate cell array for Green functions
[ obj.layer, obj.g ] = deal( layer, cell( size( varargin ) ) );

%  initialize Green function object
for i = 1 : numel( varargin )
  obj.g{ i } = greentablayer( layer, varargin{ i } );
end
