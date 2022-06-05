%  DEMOEELSSTAT3 - EELS of nanodisk for different impact parameters.
%    For a silver nanodisk with 30 nm diameter and 5 nm height, this
%    program computes the energy loss probability for different impact
%    parameters and loss energies within the quasistatic approximation.
%
%  Runtime on my computer:  70 sec.

%% initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' );
%  table of dielectric function
epstab = { epsconst( 1 ), epstable( 'silver.dat' ) };

%  diameter of disk
diameter = 30;
%  polygon for disk
poly = polygon( 25, 'size', [ 1, 1 ] * diameter );
%  edge profile for disk
edge = edgeprofile( 5, 11 );
%  extrude polygon to nanoparticle
p = comparticle( epstab, { tripolygon( poly, edge ) }, [ 2, 1 ], 1, op );

%  width of electron beam and electron velocity
[ width, vel ] = deal( 0.5, eelsbase.ene2vel( 200e3 ) );
%  impact parameters 
imp = linspace( 0, 1.4 * diameter, 81 );
%  loss energies in eV
ene = linspace( 2.5, 4.5, 60 );

%  convert energies to nm
units;  enei = eV2nm ./ ene;

%%  BEM solution
%  BEM solver
bem = bemsolver( p, op );
%  electron beam excitation
exc = electronbeam( p, imp( : ) * [ 1, 0 ], width, vel, op );
%  surface and bulk losses
[ psurf, pbulk ] = deal( zeros( numel( imp ), numel( enei ) ) );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charges
  sig = bem \ exc( enei( ien ) );
  %  EELS losses
  [ psurf( :, ien ), pbulk( :, ien ) ] = exc.loss( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
%  electron energy loss probability
imagesc( ene, imp, psurf + pbulk );  hold on
%  plot disk edge
plot( ene, 0 * ene + diameter / 2, 'w--' );

set( gca, 'YDir', 'norm' );
colorbar

xlabel( 'Loss energy (eV)' );
ylabel( 'x (nm)' );

title( 'Loss probability (eV^{-1})' );
                         
