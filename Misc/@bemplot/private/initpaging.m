function obj = initpaging( obj )
%  INITPAGING - Set up figure for paging.

%  handle to figure
h = gcf;
%  set figure name
figname( obj, gcf );

%  green arrow to right
icon = fullfile( matlabroot, '/toolbox/matlab/icons/greenarrowicon.gif' );
[ cdata, map ] = imread( icon );
% convert white pixels into a transparent background
map( sum( map, 2 ) == 3 ) = NaN;
% Convert to RGB space
icon2 = ind2rgb( cdata, map );
icon1 = icon2( :, end : -1 : 1, : );

%  get toolbar icons
tbh = findall( h, 'Type', 'uitoolbar' );
%  add left arrow to 
uipushtool( tbh, 'CData', icon1, 'Separator','on',  ...
        'HandleVisibility','off', 'TooltipString', 'Previous field',  ...
        'ClickedCallback', @( ~, ~ ) pagedn );
%  add right arrow
uipushtool( tbh, 'CData', icon2,  ...
        'HandleVisibility','off', 'TooltipString', 'Next field',  ...
        'ClickedCallback', @( ~, ~ ) pageup );
      
      
function [] = pagedn
%  PAGEDN - Page down value and vector arrays.

%  get BEMPLOT object
obj = get( gcf, 'UserData' );
%  first array element ?
if obj.opt.ind == 1,  return;  end
   
%  decrement index
obj.opt.ind = obj.opt.ind - 1;
%  refresh figure
obj = refresh( obj, 'ind' );
%  update figure name
figname( obj, gcf );

%  save BEMPLOT object in figure
set( gcf, 'UserData', obj );

      
function [] = pageup
%  PAGEUP - Page up value and vector arrays.

%  get BEMPLOT object
obj = get( gcf, 'UserData' );
%  last array element ?
if obj.opt.ind == prod( obj.siz ),  return;  end

%  increment index
obj.opt.ind = obj.opt.ind + 1;
%  refresh figure
obj = refresh( obj, 'ind' );
%  update figure name
figname( obj, gcf );

%  save BEMPLOT object in figure
set( gcf, 'UserData', obj );
