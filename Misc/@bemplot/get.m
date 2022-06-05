function obj = get( varargin )
%  GETBEMPLOT - Open new figure or get BEMPLOT variable.
%
%  Usage for obj = bemplot :
%    obj = bemplot.get( PropertyPairs )
%  PropertyValue
%    'fun'    :  plot function
%    'scale'  :  scale factor for vector function
%    'sfun'   :  scale function for vector functions

%  new figure ?
if isempty( get( 0,   'CurrentFigure' ) ) ||   ...
   isempty( get( gcf, 'CurrentAxes'   ) ) ||  isempty( get( gcf, 'UserData' ) )
  obj = bemplot( varargin{ : } );
else
  obj = init( get( gcf, 'UserData' ), varargin{ : } );
end
