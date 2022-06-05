function obj = plotarrow( obj, pos, vec, varargin )
%  PLOTARROW - Plot vector array with arrows.
%
%  Usage for obj = bemplot :
%    obj = plotarrow( obj, pos, vec, PropertyPairs )
%  Input
%    pos     :  vector positions
%    vec     :  vector array

%  initialization functions
inifun  = @( pos ) vecarray( pos, vec, 'arrow' );
inifun2 = @( var )    init2( var, vec, 'arrow' );
%  call plot function
obj = plot( obj, pos, inifun, inifun2, varargin{ : } );
