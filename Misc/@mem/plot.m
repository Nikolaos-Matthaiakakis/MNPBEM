function plot( ~ )
%  PLOT - Plot memory information.

if ~mem.flag,  return;  end

%  get report
report = mem.report;
if isempty( report ),  return;  end
%  identifier and used memory
id = report( :, 1 );
m = cell2mat( report( :, 2 ) ) .';  m = max( m ) - m;

%  bar plot
fig = figure;  bar( m / 1e9 );
xlim( [ 0, numel( m ) + 1 ] );

%  annotate plot
ylabel( 'Memory (GB)' );

%  change behavior of data cursor
h = datacursormode( fig );
set( h, 'UpdateFcn', @( ~, event ) fun( event, id ) );


function txt = fun( event, id )
% Customizes text of data tips

pos = get( event, 'Position' );
txt = { [ 'id: ', id{ pos( 1 ) } ], ...
	      [ 'mem: ', num2str( pos( 2 ) ) ] };
