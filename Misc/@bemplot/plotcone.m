function obj = plotcone( obj, pos, vec, varargin )
%  PLOTCONE - Plot vector array with cones.
%
%  Usage for obj = bemplot :
%    obj = plotcone( obj, pos, vec, PropertyPairs )
%  Input
%    pos     :  vector positions
%    vec     :  vector array

%  initialization functions
inifun  = @( pos ) vecarray( pos, vec, 'cone' );
inifun2 = @( var )    init2( var, vec, 'cone' );
%  call plot function
obj = plot( obj, pos, inifun, inifun2, varargin{ : } );
