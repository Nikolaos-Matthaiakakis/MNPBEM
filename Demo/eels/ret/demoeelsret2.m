%  DEMOEELSRET3 - EELS of nanodisk for different impact parameters.
%    For a silver nanodisk with 30 nm diameter and 5 nm height, this
%    program computes the energy loss probability for selected impact
%    parameters and loss energies using the full Maxwell equations, and
%    compares the results with those obtained within the quasistatic
%    approximation.
%
%  Runtime on my computer:  96 sec.

%% initialization
%  options for BEM simulation
op1 = bemoptions( 'sim', 'ret',  'interp', 'curv' );
op2 = bemoptions( 'sim', 'stat', 'interp', 'curv' );
%  table of dielectric function
epstab = { epsconst( 1 ), epstable( 'silver.dat' ) };

%  diameter of disk
diameter = 30;
%  polygon for disk
poly = polygon( 25, 'size', [ 1, 1 ] * diameter );
%  edge profile for disk
edge = edgeprofile( 5, 11 );
%  extrude polygon to nanoparticle
p = comparticle( epstab, { tripolygon( poly, edge ) }, [ 2, 1 ], 1, op1 );

%  width of electron beam and electron velocity
[ width, vel ] = deal( 0.5, eelsbase.ene2vel( 200e3 ) );
%  impact parameters (0, R/2, R)
imp = [ 0, 0; 0.48, 0; 0.96, 0 ] * diameter / 2;
%  loss energies in eV
ene = linspace( 2.5, 4, 40 );

%  convert energies to nm
units;  enei = eV2nm ./ ene;

%%  BEM solution
%  BEM solvers
bem1 = bemsolver( p, op1 );
bem2 = bemsolver( p, op2 );
%  electron beam excitation
exc1 = electronbeam( p, imp, width, vel, op1 );
exc2 = electronbeam( p, imp, width, vel, op2 );
%  surface and bulk losses
[ psurf1, pbulk1 ] = deal( zeros( size( imp, 1 ), numel( enei ) ) );
[ psurf2, pbulk2 ] = deal( zeros( size( imp, 1 ), numel( enei ) ) );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charges
  sig1 = bem1 \ exc1( enei( ien ) );
  sig2 = bem2 \ exc2( enei( ien ) );
  %  EELS losses
  [ psurf1( :, ien ), pbulk1( :, ien ) ] = exc1.loss( sig1 );
  [ psurf2( :, ien ), pbulk2( :, ien ) ] = exc2.loss( sig2 );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( ene, psurf1 + pbulk1 );  hold on
if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
plot( ene, psurf2 + pbulk2, '--' ); 

xlabel( 'Loss energy (eV)' );
ylabel( 'Loss probability (eV^{-1})' );

legend( '0, ret', 'R/2', 'R', '0, qs' );
