function [] = plot( obj, varargin )
%  PLOT - Plot integration points for boundary element integration.
%
%  Usage for obj = quadface :
%    [] = plot( obj, varargin )
%  Inut
%    varargin   :  parameters passed to PLOT
%  Output
%    []         :  plot integration points to screen

subplot( 1, 2, 1 );
%  plot triangle integration points
plot( obj.x, obj.y, 'b.' );  hold on;
%  plot polar triangle integration points
plot( 1 - obj.x3, 1 - obj.y3, 'r.' );
%  plot triangles
plot( [ 0, 1, 0, 0 ], [ 0, 0, 1, 0 ], 'k-' );
plot( [ 1, 1, 0, 1 ], [ 0, 1, 1, 0 ], 'k-' );

axis equal 

xlim( [ - 0.05, 1.05 ] );  xlabel( 'x' );
ylim( [ - 0.05, 1.05 ] );  ylabel( 'y' );

title( sprintf( 'nz = %i (%i)', numel( obj.x ), numel( obj.x3 ) ) );

subplot( 1, 2, 2 );
%  plot polar quadrilateral integration points
plot( obj.x4, obj.y4, 'r.' );

axis equal 

xlim( [ - 1.05, 1.05 ] );  xlabel( 'x' );
ylim( [ - 1.05, 1.05 ] );  ylabel( 'y' );

title( sprintf( 'nz = %i', numel( obj.x4 ) ) );
