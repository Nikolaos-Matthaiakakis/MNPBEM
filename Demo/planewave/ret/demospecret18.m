%  DEMOSPECRET18 - Timing for iterative BEM solver.
%    For metallic nanorods with increasing length and number of boundary
%    elements, ranging from 7378 to 21378, we measure the time for setting
%    up the BEM solver and for initialiazing the solver for a given
%    wavelength ENEI.
%
%  Runtime on my computer:  70 min.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'ret' );
%  use iterative BEM solver
op.iter = bemiter.options( 'output', 1 );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };
%  diameter of nanorod
diameter = 50;
%  length of nanorod and number of discretization points
len = [ 1000, 1500, 2000, 2500, 3000 ];
n = linspace( 500, 1500, 5 );

%  initialize COMPARTICLE array
p = cell( size( n ) );
%  loop over different rod lengths
for i = 1 : numel( n )
  p{ i } = comparticle( epstab,  ...
    { trirod( diameter, len( i ), [ 15, 15, n( i ) ] ) }, [ 2, 1 ], 1, op );
end

%%  BEM timing
%  number of boundary elements
nbound = cellfun( @( p ) p.n, p, 'uniform', 1 );
%  timing for BEM initializations
time = zeros( numel( p ), 2 );
%  wavelength for BEM initialization
enei = 800;

%  loop over different rods
for i = 1 : numel( p )
  %  initialize BEM solver
  id = tic;  bem = bemsolver( p{ i }, op );  time( i, 1 ) = toc( id );
  %  initialize BEM solver with given wavelength
  id = tic;  bem = bem( enei );  time( i, 2 ) = toc( id );
end

%%  final plot
% %  these are the results on my computer
% nbound = [ 7378, 10878, 14378, 17878, 21378 ];
% time = [  61.378, 115.308, 181.751, 301.791,  348.447;
%          187.654, 331.173, 690.264, 847.699, 1146.415 ]';   
bar( nbound, time / 60 );  hold on

set( gca, 'XTickLabel', num2cell( nbound ) );
legend( 'init', 'bem(enei)', 'Location', 'NorthWest' );

xlabel( '# boundary elements' );
ylabel( 'Time (min)' );


