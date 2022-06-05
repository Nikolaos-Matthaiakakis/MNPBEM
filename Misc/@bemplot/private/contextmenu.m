function [] = contextmenu
%  CONTEXTMENU - Add context menu to current figure.

%  context menu
h = uicontextmenu;
%  callback items for function
uimenu( h, 'Label', 'real',  'Callback',  ...
            @( ~, ~ ) bemplot.set( 'fun', @( x ) real( x ) ) );
uimenu( h, 'Label', 'imag',  'Callback',  ...
            @( ~, ~ ) bemplot.set( 'fun', @( x ) imag( x ) ) );
%  callback items for index and vector function
uimenu( h, 'Label', 'plot options',   'Callback', @( ~, ~ ) optfun );
uimenu( h, 'Label', 'tight caxis',    'Callback', @( ~, ~ ) caxfun );

%  attach menu to figure
set( gcf, 'uicontextmenu', h );

function [] = optfun( ~, ~ )
%  OPTFUN - Get plot options.

%  get BEMPLOT object
obj = get( gcf, 'UserData' );
%  plot options
opt = obj.opt;

prompt = { 'Enter the index', 'Enter the user-defined function:',  ...
           'Enter the scale parameter', 'Enter the scale function' };
def = { mat2str( opt.ind   ), func2str( opt.fun  ),  ...
        mat2str( opt.scale ), func2str( opt.sfun ) };

answer = inputdlg( prompt, 'Vector', 1, def ) ;
%  set index value
if ~isempty( answer )

  varargin = {};  
  %  index
  if ~strcmp( answer{ 1 }, def( 1 ) )
    varargin = [ varargin, { 'ind',  str2num( answer{ 1 } ) } ];
  end
  %  function
  if ~strcmp( answer{ 2 }, def( 2 ) )
    varargin = [ varargin, { 'fun',  str2func( answer{ 2 } ) } ];
  end
  %  scale parameter
  if ~strcmp( answer{ 3 }, def( 3 ) )
    varargin = [ varargin, { 'scale', str2num( answer{ 3 } ) } ];
  end
  %  scale function
  if ~strcmp( answer{ 4 }, def( 4 ) )
    varargin = [ varargin, { 'sfun',  str2func( answer{ 4 } ) } ];
  end
  
  bemplot.set( varargin{ : } );
end


function [] = caxfun( ~, ~ )
%  CAXFUN - Set tight color axis.

%  get BEMPLOT object
obj = get( gcf, 'UserData' );
%  plot options
opt = obj.opt;

%  minimum and maximum array values
cmin = cellfun( @( x ) min( x, opt ), obj.var, 'UniformOutput', false );
cmax = cellfun( @( x ) max( x, opt ), obj.var, 'UniformOutput', false );
%  set color axis
if ~isempty( min( cell2mat( cmin ) ) )
  caxis( [ min( cell2mat( cmin ) ), max( cell2mat( cmax ) ) ] );
end
