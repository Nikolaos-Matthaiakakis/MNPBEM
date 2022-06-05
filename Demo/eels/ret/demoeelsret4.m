%  DEMOEELSRET4 - EELS of nanotriangle for different impact parameters.
%    For a silver nanotriangle with 80 nm base length and 10 nm height,
%    this program computes the energy loss probability for selected impact
%    parameters and loss energies using the full Maxwell equations.
%
%  Runtime on my computer:  66 sec.

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

%  hdata
hdata = struct( 'hmax', 8 );
%  extrude polygon
p = tripolygon( poly, edge, 'hdata', hdata );
%  make particle
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%  width of electron beam and electron velocity 
[ width, vel ] = deal( 0.2, eelsbase.ene2vel( 200e3 ) );
%  impact parameters (triangle corner, middle, and midpoint of edge)
imp = [ - 45, 0; 0, 0; 25, 0 ];
%  loss energies in eV
ene = linspace( 1.5, 4.5, 40 );

%  convert energies to nm
units;  enei = eV2nm ./ ene;

%%  BEM simulation
%  BEM solver
bem = bemsolver( p, op );
%  electron beam excitation
exc = electronbeam( p, imp, width, vel, op );

%  surface and bulk loss
[ psurf, pbulk ] = deal( zeros( size( imp, 1 ), numel( enei ) ) );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over energies
for ien = 1 : length( ene )
  %  surface charges
  sig = bem \ exc( enei( ien ) );
  %  EELS losses
  [ psurf( :, ien ), pbulk( :, ien ) ] = exc.loss( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( ene, psurf + pbulk );

legend( 'Corner', 'Middle', 'Edge' );

xlabel( 'Loss energy (eV)' );
ylabel( 'Loss probability (eV^{-1})' );
