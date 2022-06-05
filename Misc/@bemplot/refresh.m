function obj = refresh( obj, varargin )
%  REFRESH - Refresh value and vector plots.
%
%  Usage for obj = bemplot :
%    obj = refresh( obj, key )
%  Input
%    key    :  'ind', 'fun', 'scale', or 'sfun'

%  find value and vector arrays that depend on input keys
ind = find( cellfun( @( var ) depends( var, varargin{ : } ), obj.var ) );
%  update value array
obj.var( ind ) = cellfun( @( var ) plot( var, obj.opt ), obj.var( ind ),  ...
                                               'UniformOutput', false );

%  update figure name
figname( obj );
%  set plot options
lighting phong;  
shading interp;     
