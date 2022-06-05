%  DEMOSPECRET19 - Light scattering of gold nanosphere chain.
%    For a linear chain of metallic nanospheres and an incoming plane wave,
%    this program computes the scattering cross section for different light
%    wavelengths using the full Maxwell equations and an iterative BEM
%    solver.
%
%  Runtime on my computer:  19 min.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv' );
%  use iterative BEM solver
%    Output flag controls information about number of iterations and timing
%    of matrix evaluations.  For comparison you might also like to run the
%    program w/o iterative solvers by commenting the next line.
op.iter = bemiter.options( 'output', 0 );

%  diameter of sphere
diameter = 50;
%  nanosphere
p1 = trisphere( 144, diameter );

%  grid for spheres
[ n1, n2 ] = ndgrid( 0 : 9, 0 );
[ n1, n2 ] = deal( reshape( n1, 1, [] ), reshape( n2, 1, [] ) );
%  lattice constant and number of spheres
a = 100;
n = numel( n1 );

%  background and metal dielectric functions
epsb = epsconst( 1 );
epsm = arrayfun( @( ~ ) epstable( 'gold.dat' ), n1( : ) .', 'uniform', 0 );
%  array for dielectric functions 
epstab = [ { epsb }, epsm ];
%  sphere array
p = arrayfun( @( n1, n2 ) shift( p1, [ n1, n2, 0 ] * a ), n1, n2, 'uniform', 0 );
inout = [ 2 : n + 1; ones( 1, n ) ] .';
%  closed argument
closed = num2cell( 1 : n );

%  COMPARTICLE object for sphere array
p = comparticle( epstab, p, inout, closed{ : }, op );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );

%  plane wave excitation
exc = planewave( [ 1, 0, 0; 0, 0, 1 ], [ 0, 0, 1; 1, 0, 0 ], op );
%  light wavelength in vacuum
enei = linspace( 400, 900, 40 );
%  allocate scattering and extinction cross sections
sca = zeros( length( enei ), 2 );
ext = zeros( length( enei ), 2 );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charge
  sig = bem \ exc( p, enei( ien ) );
  %  scattering and extinction cross sections
  sca( ien, : ) = exc.sca( sig );
  ext( ien, : ) = exc.ext( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( enei, sca, 'o-'  );  hold on;

xlabel( 'Wavelength (nm)' );
ylabel( 'Scattering cross section (nm^2)' );

legend( 'x-pol', 'z-pol' );
