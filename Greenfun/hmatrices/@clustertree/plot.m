function plot( obj )
%  PLOT - Plot cluster tree.
%
%  Usage for obj = clustertree :
%    plot( obj )

%  sons and nodes of tree
son = obj.son;
nodes = zeros( 1, max( son( : ) ) );
%  fill tree
nodes = treenodes( son, nodes, 1 );

%  plot tree
fig = figure;
treeplot( nodes );
%  get vertices of tree
[ x, y ] = treelayout( nodes );
%  set new data cursor
set( datacursormode( fig ),  ...
    'UpdateFcn', @( ~, event ) ( mycursor( son, x, y, event ) ) );  


function nodes = treenodes( son, nodes, i )
%  TREENODES - Fill tree for TREEPLOT.

if any( son( i, : ) )
  nodes( son( i, : ) ) = i;
  %  continue with leaves
  nodes = treenodes( son, nodes, son( i, 1 ) );
  nodes = treenodes( son, nodes, son( i, 2 ) );
end


function txt = mycursor( son, x, y, event )
%  MYCURSOR - Text for position.

pos = get( event, 'Position' );
%  distance between position and collocation points
d = sqrt( ( pos( 1 ) - x ) .^ 2 + ( pos( 2 ) - y ) .^ 2 );
%  index to smallest element
ind = find( d < 1e-10 );

if all( son( ind, : ) == 0 )
  txt = { sprintf( 'node %i', ind ) };
else
  txt = { sprintf( 'node %i\nsons (%i,%i)', ind, son( ind, 1 ), son( ind, 2 ) ) };
end
