%  DEMOEELSRET7 - EEL spectra for silver nanotriangle on membrane.
%    For a silver nanotriangle with 80 nm base length and 10 nm height,
%    which is located on a 15 nm thin membrane, this program computes the
%    energy loss probabilities for selected impact parameters using the
%    full Maxwell equations.
%
%  Runtime on my computer:  9 min.

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
%  width of electron beam and electron velocity 
[ width, vel ] = deal( 0.2, eelsbase.ene2vel( 200e3 ) );
%  impact parameters (triangle corner, middle, and midpoint of edge)
imp = [ - 45, 0; 0, 0; 25, 0 ];
%  loss energies in eV
ene = linspace( 1.3, 4.3, 40 );

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

xlim( [ min( ene ), max( ene ) ] );

legend( 'Corner', 'Middle', 'Edge' );

xlabel( 'Loss energy (eV)' );
ylabel( 'Loss probability (eV^{-1})' );

