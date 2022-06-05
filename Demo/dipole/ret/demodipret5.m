%  DEMODIPRET5 - Photonic LDOS for nanotriangle (contd).
%    For a silver nanotriangle with 80 nm base length and 10 nm height,
%    this program computes the photonic LDOS in a plane 10 nm below the
%    nanoparticle and for transition dipole energies tuned to a few
%    selected plasmon resonances (extracted from DEMODIPRET4) using the
%    full Maxwell equations.
%
%  Runtime on my computer:  2 min.

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

%  set up COMPARTICLE objects
p = comparticle( epstab, { tripolygon( poly, edge ) }, [ 2, 1 ], 1, op );

%%  dipole oscillator
%  transition energies (eV), extracted from DEMODIPRET5
ene = [ 2.14, 2.84, 3.04, 3.23, 3.49, 3.7 ];
%  transform to wavelengths
units;
enei = eV2nm ./ ene;

%  positions
x = linspace( - 70, 50, 31 );
y = linspace( - 60, 60, 31 );
%  make grid
[ verts, faces ] = fvgrid( x( : ), y( : ) );
%  make particle
plate = shift( particle( verts, faces ), [ 0, 0, - 15 ] );

%  compoint
pt = compoint( p, plate.verts );
%  dipole excitation
dip = dipole( pt, op );
%  initialize total and radiative scattering rate
[ tot, rad ] = deal( zeros( numel( x ) * numel( y ), numel( enei ), 3 ) );

%%  BEM simulation
%  set up BEM solver
bem = bemsolver( p, op );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charges
  sig = bem \ dip( p, enei( ien ) );
  %  total and radiative decay rate
  [ tot( :, ien, : ), rad( :, ien, : ) ] = dip.decayrate( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
%  plot particle (comment following lines if you have problems with FaceAlpha)
plot( p, 'FaceAlpha', 0.5 );
%  plot photonic LDOS
plot( plate, sum( tot, 3 ) / 3 );
