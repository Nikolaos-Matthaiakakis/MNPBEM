%  DEMOEELSRET6 - Electric field map for EELS of nanotriangle.
%    For a silver nanotriangle with 80 nm base length and 10 nm height,
%    this program computes the electric field maps for (i) the excitation
%    of the dipole mode at 2.13 eV at the triangle edge and (ii) the
%    excitation of the breathing mode at 3.48 eV at the triangle center.
%
%  Runtime on my computer:  51 sec.

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
hdata = struct( 'hmax', 5 );
%  extrude polygon
p = tripolygon( poly, edge, 'hdata', hdata );
%  make particle
p = comparticle( epstab, { p }, [ 2, 1 ], 1, op );

%  width of electron beam and electron velocity 
[ width, vel ] = deal( 0.2, eelsbase.ene2vel( 200e3 ) );
%  impact parameters (triangle corner, middle, and midpoint of edge)
imp = [ - 40, 0; 0, 0 ];
%  loss energies in eV (dipole and breathing mode)
ene = [ 2.13, 3.58 ];

%  convert energies to nm
units;  enei = eV2nm ./ ene;

%%  BEM simulation
%  BEM solver
bem = bemsolver( p, op );
%  electron beam excitation
exc1 = electronbeam( p, imp( 1, : ), width, vel, op );
exc2 = electronbeam( p, imp( 2, : ), width, vel, op );
%  surface charges
sig1 = bem \ exc1( enei( 1 ) );
sig2 = bem \ exc2( enei( 2 ) );

%%  computation of electric field
%  mesh for calculation of electric field
[ x, z ] = meshgrid( linspace( - 60, 60, 81 ) );
%  object for electric field
%    MINDIST controls the minimal distance of the field points to the
%    particle boundary
emesh = meshfield( p, x, 0, z, op, 'mindist', 0.4, 'nmax', 3000 );
%  induced and incoming electric field
e1 = emesh( sig1 );  ee1 = sqrt( dot( e1, e1, 3 ) );
e2 = emesh( sig2 );  ee2 = sqrt( dot( e2, e2, 3 ) );

%%  final plot
%  plot electric field for dipole mode
subplot( 1, 2, 1 );  imagesc( x( : ), z( : ), log10( ee1 ) );  
%  plot electron trajectory
hold on;  plot( imp( 1 ) * [ 1, 1 ], 60 * [ - 1, 1 ], 'w:' );

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );
title( 'Dipole mode (log. scale)' );

colorbar( 'NorthOutside' );  caxis( [ - 1, 1 ] );
set( gca, 'YDir', 'norm' );  
axis equal tight

%  plot electric field for hexapole mode
subplot( 1, 2, 2 );  imagesc( x( : ), z( : ), log10( ee2 ) ); 
%  plot electron trajectory
hold on;  plot( imp( 2 ) * [ 1, 1 ], 60 * [ - 1, 1 ], 'w:' );

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );
title( 'Breathing mode (log. scale)' );

colorbar( 'NorthOutside' );  caxis( [ - 1, 1 ] );
set( gca, 'YDir', 'norm' ); 
axis equal tight

colormap hot( 255 );
