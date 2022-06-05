%  DEMODIPRET3 - Photonic LDOS for a silver nanodisk.
%    For a silver nanodisk with a diameter of 30 nm and a height of 5 nm,
%    we compute the photonic LDOS for selected positions (0, R/2, R, 3R/2,
%    2.5 nm above nanoparticle) and for different transition dipole
%    energies using the full Maxwell equations, and compare the reuslts
%    with those obtained within the quasistatic approximation.
%
%  Runtime on my computer:  2 min.

%%  initialization
%  options for BEM simulation
op1 = bemoptions( 'sim', 'stat', 'interp', 'curv' );
op2 = bemoptions( 'sim', 'ret',  'interp', 'curv' );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'silver.dat' ) };

%  polygon for disk
poly = polygon( 25, 'size', [ 30, 30 ] );
%  edge profile for triangle
edge = edgeprofile( 5, 11 );
%  refine function
refun = @( pos, ~ ) 0.8 + abs( pos( :, 2 ) ) .^ 2 + 5 * ( pos( :, 1 ) < 0 );

%  upper plate for polygon, we only refine the upper plate
[ p1, poly ] = plate( polygon3( poly, edge.zmax ), 'edge', edge, 'refun', refun );
%  ribbon around polygon
p2 = vribbon( poly );
%  lower plate
p3 = plate( set( poly, 'z', edge.zmin ), 'dir', - 1 );

%  set up COMPARTICLE objects
p = comparticle( epstab, { vertcat( p1, p2, p3 ) }, [ 2, 1 ], 1, op1 );

%%  dipole oscillator
%  transition energies (eV)
ene = linspace( 2.5, 4, 60 );
%  transform to wavelengths
units;
enei = eV2nm ./ ene;

%  positions
x = [ 0, 6, 12, 18 ];
%  compoint
pt = compoint( p, [ x( : ), 0 * x( : ), 0 * x( : ) + 5 ] );
%  dipole excitations
dip1 = dipole( pt, op1 );
dip2 = dipole( pt, op2 );
%  initialize total and radiative scattering rate
[ tot1, rad1 ] = deal( zeros( numel( enei ), numel( x ), 3 ) );
[ tot2, rad2 ] = deal( zeros( numel( enei ), numel( x ), 3 ) );

%%  BEM simulation
%  set up BEM solvers
bem1 = bemsolver( p, op1 );
bem2 = bemsolver( p, op2 );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charges
  sig1 = bem1 \ dip1( p, enei( ien ) );
  sig2 = bem2 \ dip2( p, enei( ien ) );
  %  total and radiative decay rate
  [ tot1( ien, :, : ), rad1( ien, :, : ) ] = dip1.decayrate( sig1 );
  [ tot2( ien, :, : ), rad2( ien, :, : ) ] = dip2.decayrate( sig2 );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
%  plot photonic LDOS at different positions
plot( ene, sum( tot1, 3 ) / 3, '-'  );  hold on
if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
plot( ene, sum( tot2, 3 ) / 3, '--' );

xlabel( 'Transition dipole energy (eV)' );
ylabel( 'Photonic LDOS enhancement' );

legend( '0', 'R/2', 'R', '3R/2' );

% %  one may additionally plot the surface charge distribution with
% plot( p, sig1.sig );
