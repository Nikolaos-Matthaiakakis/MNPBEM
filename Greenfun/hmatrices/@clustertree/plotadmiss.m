function plotadmiss( obj, varargin )
%  PLOTADMISS - Plot admissibility matrix.
%
%  Usage for obj = clustertree :
%    plotadmiss( obj )
%    plotadmiss( obj, op, PropertyPairs )
%  Input
%    op     :  option structure (same arguments as passed to BEMSOLVER)
%  Output
%    plot of admissibility matrix

%  allocate array
mat = zeros( matsize( obj, obj ), 'uint16' );
%  find full and low-rank matrices
ad = admissibility( obj, obj, varargin{ : } );
[ row1, col1 ] = find( ad == 2 );
[ row2, col2 ] = find( ad == 1 );
%  cluster indices
[ cind1, cind2 ] = deal( obj.cind, obj.cind );
%  loop over clusters
for i = 1 : numel( row2 )
  mat( cind1( row2( i ), 1 ) : cind2( row2( i ), 2 ),     ...
       cind2( col2( i ), 1 ) : cind2( col2( i ), 2 ) ) = 1;
end  

%  plot matrix
fig = figure;
imagesc( mat );  hold on;

%  box coordinates for cluster
[ x, y ] = arrayfun( @( i1, i2 )  ...
  box( cind1, cind2, i1, i2 ), row2, col2, 'uniform', 0 );  
%  plot cluster boundaries
plot( cell2mat( transpose( x ) ), cell2mat( transpose( y ) ), 'k-' );

%  set new data cursor
set( datacursormode( fig ),  ...
    'UpdateFcn', @( ~, event ) ( mycursor( obj, row1, col1, row2, col2, event ) ) );  


function [ x, y ] = box( cind1, cind2, i1, i2 )
%  BOX - Box coordinates for cluster.

%  cluster indices
cind1 = cind1( i1, : ) + 0.5 * [ -1, 1 ];
cind2 = cind2( i2, : ) + 0.5 * [ -1, 1 ];  
%  box coordinates
x = [ cind2( 1 ), cind2( 2 ), cind2( 2 ), cind2( 1 ), nan ];
y = [ cind1( 1 ), cind1( 1 ), cind1( 2 ), cind1( 2 ), nan ];


function txt = mycursor( obj, row1, col1, row2, col2, event )
%  MYCURSOR - Text for position.

pos = get( event, 'Position' );
%  index to full matrices
ind1 = pos( 1 ) > obj.cind( row1, 1 ) & pos( 1 ) < obj.cind( row1, 2 ) &  ...
       pos( 2 ) > obj.cind( col1, 1 ) & pos( 2 ) < obj.cind( col1, 2 );
%  index to low-rank matrices
ind2 = pos( 1 ) > obj.cind( row2, 1 ) & pos( 1 ) < obj.cind( row2, 2 ) &  ...
       pos( 2 ) > obj.cind( col2, 1 ) & pos( 2 ) < obj.cind( col2, 2 );
    
if any( ind1 )
  txt = { sprintf( '(%i,%i)', row1( ind1 ), col1( ind1 ) ) };
elseif any( ind2 )
  txt = { sprintf( '(%i,%i)', row2( ind2 ), col2( ind2 ) ) };
else
  txt = { '' };
end
