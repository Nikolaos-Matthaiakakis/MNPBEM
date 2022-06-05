function obj = plot( obj, p, inifun, inifun2, varargin )
%  PLOT - Plot value or vector array.
%
%  Usage for obj = bemplot :
%    obj = plot( obj, p, inifun, inifun2, PropertyPairs )
%  Input
%    p          :  particle surface or vector positions
%    inifun     :  first initialization of value or vector array
%    inifun2    :     re-initialization of value or vector array
%  PropertyPairs
%    to be passed to plot function

%  initialize value array
var = inifun( p );
%  handle size argument of value array
if ispage( var ) && ~isempty( obj.siz )
  assert( all( pagesize( var ) == obj.siz ) );
end

%  has particle been plotted before ?
ind = find( cellfun( @( var ) isbase( var, p ), obj.var ) );

if isempty( ind )
  %  save value array
  [ ind, obj.var{ end + 1 } ] = deal( numel( obj.var ) + 1, var );
else
  %  save value array
  obj.var{ ind } = inifun2( obj.var{ ind } );
end

%  handle SIZ argument
if ispage( obj.var{ ind } ) && isempty( obj.siz )
  [ obj.siz, obj.opt.ind ] = deal( pagesize( obj.var{ ind } ), 1 );
  %  initialize paginig
  initpaging( obj );
end

%  plot value array
obj.var{ ind } = plot( obj.var{ ind }, obj.opt, varargin{ : } );
%  lighting
if isempty( findobj( gcf, 'type', 'light' ) ),  camlight headlight;  end
%  set plot options
lighting phong;  
shading interp;  

%  save object to figure
set( gcf, 'UserData', obj );
