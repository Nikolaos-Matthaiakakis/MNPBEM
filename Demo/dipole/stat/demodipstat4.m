%  DEMODIPSTAT4 - Photonic LDOS for a silver nanodisk.
%    For a silver nanodisk we compute the photonic LDOS for different
%    positions and energies within the quasistatic approximation.  This
%    programs shows how to produce a nanodisk with a refined discretization
%    for LDOS simulations.
%
%  Runtime on my computer:  37 sec.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'silver.dat' ) };

%  polygon for disk
poly = polygon( 25, 'size', [ 30, 30 ] );
%  edge profile for triangle
edge = edgeprofile( 5, 11 );
%  refine function
refun = @( pos, ~ ) 0.5 + abs( pos( :, 2 ) ) .^ 2 + 5 * ( pos( :, 1 ) < 0 );

%  extrude polygon to nanoparticle
[ p, poly ] = tripolygon( poly, edge, 'refun', refun );

%  set up COMPARTICLE object
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%%  dipole oscillator
%  transition energies (eV)
ene = linspace( 1.5, 4, 60 );
%  transform to wavelengths
units;
enei = eV2nm ./ ene;

%  positions
x = reshape( linspace( 0, 30, 70 ), [], 1 );
%  compoint
pt = compoint( p, [ x, 0 * x, 0 * x + 3.5 ] );
%  dipole excitation
dip = dipole( pt, op );
%  initialize total and radiative scattering rate
[ tot, rad ] = deal( zeros( numel( enei ), numel( x ), 3 ) );

%%  BEM simulation
%  set up BEM solver
%    we use an eigenmode expansion to speed up the simulation
bem = bemsolver( p, op, 'nev', 50 );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charge
  sig = bem \ dip( p, enei( ien ) );
  %  total and radiative decay rate
  [ tot( ien, :, : ), rad( ien, :, : ) ] = dip.decayrate( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
%  density plot of total scattering rate (LDOS)
imagesc( ene, x, log10( sum( tot, 3 ) ) .' );  hold on
%  plot disk edge
plot( ene, 0 * ene + 15, 'w--' );

set( gca, 'YDir', 'norm' );
colorbar

xlabel( 'Energy (eV)' );
ylabel( 'x (nm)' );

title( 'LDOS for silver nanodisk' );
