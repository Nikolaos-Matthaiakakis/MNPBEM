function obj = tocout( obj, key, varargin )
%  TOCOUT - Intermediate output for BEM step.

if ~obj.output || isempty( obj.precond ),  return;  end
%  timer statistics
timer = obj.timer;

switch key
  case 'init'
    %  initialize structure (if needed)
    if isempty( timer )
      timer = struct( 'names', varargin, 'toc', [] );  
    end
    timer.toc = [ timer.toc; zeros( size( timer.names ) ) ];
    %  initialize figure
    h1 = figure;
    h2 = bar( timer.toc .', 0.6 );
    xlim( [ 0.5, numel( timer.names ) + 0.5 ] );
    ylim( [ 0, max( [ timer.toc( : ); 0.1 ] ) ] );
    %  annotate plot
    set( gca, 'XTickLabel', timer.names, 'XTickLabelRotation', 90 );
    ylabel( 'Elapsed time (sec)' );
    %  change position
    pos = get( h1, 'Position' );
    pos( [ 2, 4 ] ) = [ 500, 250 ];
    set( h1, 'Position', pos );
    %  remove menu 
    set( h1, 'MenuBar', 'none' );
    set( h1, 'ToolBar', 'none' );
    set( h1, 'resize', 'off' );
    drawnow;
    %  initialize timer
    [ timer.h1, timer.h2 ] = deal( h1, h2 );
    timer.id = tic; 
  case 'close'
    %  save total time
    timer.toc = [ timer.toc( end, 1 : end - 1 ), toc( timer.id ) ];
    set( timer.h2( end ), 'YData', timer.toc );  ylim auto;
    %  close figure
    close( timer.h1 );
  otherwise
    %  save time
    timer.toc( end, strcmp( key, timer.names ) ) = toc( timer.id );
    timer.id = tic;
    %  update figure
    set( timer.h2( end ), 'YData', timer.toc( end, : ) );  ylim auto;
    drawnow;
end

%  save timer
obj.timer = timer;
