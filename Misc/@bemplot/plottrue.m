function obj = plottrue( obj, p, varargin )
%  PLOTTRUE - Plot value array with true colors on surface.
%
%  Usage for obj = bemplot :
%    obj = plottrue( obj, p,      PropertyPairs )
%    obj = plottrue( obj, p, val, PropertyPairs )
%  Input
%    p       :  particle surface
%    val     :  value array

%  handle input
if ~isempty( varargin ) && ~ischar( varargin{ 1 } )
  [ val, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
else
  val = [];
end

%  initialization functions
inifun  = @( p   ) valarray( p, val, 'truecolor' );
inifun2 = @( var )  init2( var, val, 'truecolor' );
%  call plot function
obj = plot( obj, p, inifun, inifun2, varargin{ : } );
