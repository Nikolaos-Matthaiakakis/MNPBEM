function obj = init( obj, varargin )
%  INIT - Initialization of BEMPLOT object.
%
%  Usage for obj = bemplot :
%    obj = init( obj, PropertyPairs )
%  PropertyValue
%    'fun'    :  plot function
%    'scale'  :  scale factor for vector array
%    'sfun'   :  scale function for vector array

%  new figure ?
if isempty( get( 0, 'CurrentFigure' ) ) || isempty( get( gcf, 'CurrentAxes' ) )
  axis off;  axis equal;  axis fill;
  view( 1, 40 );
  %  set context menu
  contextmenu;
end

%  set default values
if isempty( obj.opt )
  obj.opt =  ...
    struct( 'ind', [], 'fun', @( x ) real( x ), 'scale', 1, 'sfun', @( x ) x );
end

%  extract input
op = getbemoptions( varargin{ : } );
%  set fields
if isfield( op, 'fun'   ),  obj.opt.fun   = op.fun;    end
if isfield( op, 'scale' ),  obj.opt.scale = op.scale;  end
if isfield( op, 'sfun'  ),  obj.opt.sfun  = op.sfun;   end

%  set figure name
figname( obj );
