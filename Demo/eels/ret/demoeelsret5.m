%  DEMOEELSRET5 - EELS maps of nanotriangle for selected loss energies.
%    For a silver nanotriangle with 80 nm base length and 10 nm height,
%    this program computes EELS maps for selected loss energies using the
%    full Maxwell equations.
%
%  Runtime on my computer:  83 sec.

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

%%  EELS excitation
%  units
units;
%  loss energies (extracted from DEMOEELSRET4)
ene = [ 2.13, 2.82, 3.04, 3.48 ];
%  wavelengths
enei = eV2nm ./ ene;

%  mesh for electron beams
[ x, y ] = meshgrid( linspace( - 70, 50, 50 ), linspace( 0, 50, 35 ) );
%  impact parameters
impact = [ x( : ), y( : ) ];
%  width of electron beam and electron velocity 
[ width, vel ] = deal( 0.2, eelsbase.ene2vel( 200e3 ) );

%%  BEM simulation
%  BEM solver
bem = bemsolver( p, op );
%  EELS excitation
exc = electronbeam( p, impact, width, vel, op );
%  electron energy loss probabilities
[ psurf, pbulk ] = deal( zeros( size( impact, 1 ), length( enei ) ) );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over energies
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
%  x and y limits
xx = [   min( x( : ) ), max( x( : ) ) ];
yy = [ - max( y( : ) ), max( y( : ) ) ];

%  plot EELS maps
for i = 1 : 4
    
  subplot( 2, 2, i );
  
  %  reshape loss probability
  prob = reshape( psurf( :, i ) + pbulk( :, i ), size( x ) );
  %  add second part of triangle
  imagesc( xx, yy, [ flipud( prob( 2 : end, : ) ); prob ] ); 

  set( gca, 'YDir', 'norm' );
  colormap hot( 255 );

  xlabel( 'x (nm)' );
  ylabel( 'y (nm)' );
  
  title( subsref( { '2.13 eV', '2.82 eV', '3.04 eV', '3.48 eV' },  ...
                                          substruct( '{}', { i } ) ) );
end
