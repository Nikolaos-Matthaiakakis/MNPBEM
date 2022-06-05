function [] = particlecursor( p, ind )
%  PARTICLECURSOR - Find surface elements of discretized particle surface.
%
%  Usage :
%    particlecursor( p )
%    particlecursor( p, ind )
%  Input
%    p      :  discretized particle surface
%    ind    :  index to face elements to be highlighted
%  Output
%    Displays selected bundary elements (ind) or allows the user to select
%    faces of the discretized particle surface via the Data Cursor.

%  plot particle
fig = figure;
if ~exist( 'ind', 'var' )
  plot2( p, 'EdgeColor', 'b' );  hold on; 
  %  plot particle faces
  plot3( p.pos( :, 1 ), p.pos( :, 2 ), p.pos( :, 3 ), 'r.' );
  %  set new data cursor
  set( datacursormode( fig ),  ...
    'UpdateFcn', @( ~, event ) ( mycursor( p, event ) ) );  
else
  if length( ind ) == 1;  ind = [ ind, ind ];  end
  [ p2, p1 ] = select( particle( p.verts, p.faces ), 'index', ind );
  plot2( p1, 'EdgeColor', 'b' );  hold on; 
  plot2( p2, 'FaceColor', [ 1, 0, 0 ] );
end


function txt = mycursor( p, event )
%  MYCURSOR - Text for position.

pos = get( event, 'Position' );
%  distance between position and collocation points
d = sqrt( sum( ( p.pos - repmat( pos, p.n,  1 ) ) .^ 2, 2 ) );
%  index to smallest element
ind = find( d < 1e-10 );

if ~isempty( ind )
  txt = { num2str( ind ) };
else
  txt = { '' };
end
