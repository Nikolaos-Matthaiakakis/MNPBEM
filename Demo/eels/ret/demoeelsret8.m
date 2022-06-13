%  DEMOEELSRET8 - EELS maps for silver nanotriangle on membrane.
%    For a silver nanotriangle with 80 nm base length and 10 nm height,
%    which is located on a 15 nm thin membrane, this program computes the
%    EELS maps for selected loss energies using the full Maxwell equations.
%
%  Runtime on my computer:  6 min.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv', 'eels.refine', 2 );
%  table of dielectric functions
epstab  = { epsconst( 1 ), epstable( 'silver.dat' ), epsconst( 4 ) };

%  dimensions of particle
len = [ 80, 80 * 2 / sqrt( 3 ) ];
%  polygon
poly = round( polygon( 3, 'size', len ) ); 
%  edge profile
%    MODE '01' produces a rounded edge on top and a sharp edge on bottom,
%    MIN controls the lower z-value of the nanoparticle 
edge = edgeprofile( 10, 11, 'mode', '01', 'min', 0 );

%  hdata
hdata = struct( 'hmax', 8 );
%  extrude polygon
[ p, poly ] = tripolygon( poly, edge, 'hdata', hdata );
%  split init upper and lower part
[ pup, plo ] = select( p, 'carfun', @( x, y, z ) z > 1e-3 );

%  polygon for plate
poly2 = polygon3( polygon( 4, 'size', [ 150, 150 ] ), 0 );
%  upper plate
up = plate( [ poly2, set( poly, 'z', 0 ) ], 'dir', - 1 );
%  lower plate, we use FVGRID to get quadrilateral face elements
x = 150 * linspace( - 0.5, 0.5, 21 );
[ verts, faces ] = fvgrid( x, x );
%  make particle
lo = flipfaces( shift( particle( verts, faces ), [ 0, 0, - 15 ] ) );

%  make particle
p = comparticle( epstab, { pup, plo, up, lo },  ...
                   [ 2, 1; 2, 3; 1, 3; 3, 1 ], [ 1, 2 ], op );

%%  EELS excitation
%  loss energies (extracted from DEMOEELSRET7)
ene = [ 1.60, 2.15, 2.38, 2.90 ];
%  convert energies to nm
units;  enei = eV2nm ./ ene;

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
  
  title( subsref( { '1.60 eV', '2.15 eV', '2.38 eV', '2.90 eV' },  ...
                                          substruct( '{}', { i } ) ) );
end
