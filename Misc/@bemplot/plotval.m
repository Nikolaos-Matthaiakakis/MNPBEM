function obj = plotval( obj, p, val, varargin )
%  PLOTVAL - Plot value array on surface.
%
%  Usage for obj = bemplot :
%    obj = plotval( obj, p, val, PropertyPairs )
%  Input
%    p       :  particle surface
%    val     :  value array

%  initialization functions
inifun  = @( p   ) valarray( p, val );
inifun2 = @( var )  init2( var, val );
%  call plot function
obj = plot( obj, p, inifun, inifun2, varargin{ : } );
