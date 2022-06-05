%  DEMODIPRET4 - Photonic LDOS for nanotriangle.
%    For a silver nanotriangle with 80 nm base length and 10 nm height,
%    this program computes the photonic LDOS for selected positions
%    (corner, center, edge, 5 nm above nanoparticle) and for different
%    transition dipole energies using the full Maxwell equations.
%
%  Runtime on my computer:  3.5 min.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv' );
%  table of dielectric functions
epstab  = { epsconst( 1 ), epstable( 'silver.dat' ) };

%  dimensions of particle
len = [ 80, 80 * 2 / sqrt( 3 ) ];
%  polygon
poly = round( polygon( 3, 'size', len ) ); 
%  edge profile
edge = edgeprofile( 10, 11 );

%  refine function
refun = @( pos, ~ ) 2 + 0.8 * abs( pos( :, 2 ) ) .^ 2;
%  upper plate for polygon, we only refine the upper plate
[ p1, poly ] = plate( polygon3( poly, edge.zmax ), 'edge', edge, 'refun', refun );
%  ribbon around polygon
p2 = vribbon( poly );
%  lower plate
p3 = plate( set( poly, 'z', edge.zmin ), 'dir', - 1 );

%  set up COMPARTICLE objects
p = comparticle( epstab, { vertcat( p1, p2, p3 ) }, [ 2, 1 ], 1, op );


%%  dipole oscillator
%  transition energies (eV)
ene = linspace( 1.5, 4, 40 );
%  transform to wavelengths
units;
enei = eV2nm ./ ene;

%  positions
x = [ - 45, 0, 25 ];
%  compoint
pt = compoint( p, [ x( : ), 0 * x( : ), 0 * x( : ) + 10 ] );
%  dipole excitation
dip = dipole( pt, op );
%  initialize total and radiative scattering rate
[ tot, rad ] = deal( zeros( numel( enei ), numel( x ), 3 ) );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charges
  sig = bem \ dip( p, enei( ien ) );
  %  total and radiative decay rate
  [ tot( ien, :, : ), rad( ien, :, : ) ] = dip.decayrate( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
%  plot photonic LDOS at different positions
plot( ene, sum( tot, 3 ) / 3, '-'  );  hold on

xlabel( 'Transition dipole energy (eV)' );
ylabel( 'Photonic LDOS enhancement' );

legend( 'Corner', 'Center', 'Edge' );
