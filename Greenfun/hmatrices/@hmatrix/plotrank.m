function plotrank( obj )
%  PLOTRANK - Plot rank of hierarchical matrix.
%
%  Usage for obj = hmatrix :
%    plotrank( obj )

%  allocate array
mat = zeros( matsize( obj.tree, obj.tree ), 'uint16' );
%  cluster indices
[ cind1, cind2 ] = deal( obj.tree.cind, obj.tree.cind );
%  loop over clusters
for i = 1 : numel( obj.row2 )
  mat( cind1( obj.row2( i ), 1 ) : cind2( obj.row2( i ), 2 ),     ...
       cind2( obj.col2( i ), 1 ) : cind2( obj.col2( i ), 2 ) ) =  ...
                                     size( obj.lhs{ i }, 2 );
end  

%  plot matrix
fig = figure;
imagesc( mat );  hold on;

%  box coordinates for cluster
[ x, y ] = arrayfun( @( i1, i2 )  ...
  box( cind1, cind2, i1, i2 ), obj.row2, obj.col2, 'uniform', 0 );  
%  plot cluster boundaries
plot( cell2mat( transpose( x ) ), cell2mat( transpose( y ) ), 'k-' );

%  set new data cursor
set( datacursormode( fig ),  ...
    'UpdateFcn', @( ~, event ) ( mycursor( obj, mat, event ) ) );  


function [ x, y ] = box( cind1, cind2, i1, i2 )
%  BOX - Box coordinates for cluster.

%  cluster indices
cind1 = cind1( i1, : ) + 0.5 * [ -1, 1 ];
cind2 = cind2( i2, : ) + 0.5 * [ -1, 1 ];  
%  box coordinates
x = [ cind2( 1 ), cind2( 2 ), cind2( 2 ), cind2( 1 ), nan ];
y = [ cind1( 1 ), cind1( 1 ), cind1( 2 ), cind1( 2 ), nan ];


function txt = mycursor( obj, mat, event )
%  MYCURSOR - Text for position.

pos = get( event, 'Position' );
cind = obj.tree.cind;
%  index to full matrices
ind1 = pos( 1 ) > cind( obj.row1, 1 ) & pos( 1 ) < cind( obj.row1, 2 ) &  ...
       pos( 2 ) > cind( obj.col1, 1 ) & pos( 2 ) < cind( obj.col1, 2 );
%  index to low-rank matrices
ind2 = pos( 1 ) > cind( obj.row2, 1 ) & pos( 1 ) < cind( obj.row2, 2 ) &  ...
       pos( 2 ) > cind( obj.col2, 1 ) & pos( 2 ) < cind( obj.col2, 2 );
    
if any( ind1 )
  txt = { sprintf( '(%i,%i)', obj.row1( ind1 ), obj.col1( ind1 ) ) };
elseif any( ind2 )
  txt = { sprintf( 'rank=%i (%i,%i)', mat( pos( 1 ), pos( 2 ) ),  ...
                           obj.row2( ind2 ), obj.col2( ind2 ) ) };
else
  txt = { '' };
end