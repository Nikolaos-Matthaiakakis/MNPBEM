%  DEMOSPECSTAT16 - Field enhancement for nanodisk with mirror symmetry.
%    For a metallic nanodisk and an incoming plane wave with a
%    polarization along y, this program computes and plots the field
%    enhancement within the quasistatic approximation using mirror
%    symmetry.  Only the surface charges are computed with mirror symmetry,
%    the field enhancement is computed for the expanded particle and
%    surface charge.
%
%  Runtime on my computer:  9.2 sec.

%  options for BEM simulation with and w/o mirror symmetry
op1 = bemoptions( 'sim', 'stat', 'interp', 'curv', 'sym', 'xy', 'waitbar', 0 );
op2 = rmfield( op1, 'sym' );
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ) };

%  polygon for triangle
poly = polygon( 30, 'size', [ 30, 30 ] );
%  edge profile for triangle
edge = edgeprofile( 5, 11 );
%  extrude polygon to nanoparticle 
%    the OP structure ensures that the extruded polygon has the right
%    symmetry
p = tripolygon( poly, edge, op1 );

%  set up COMPARTICLE objects
p1 = comparticlemirror( epstab, { p }, [ 2, 1 ], 1, op1 );

%%  BEM simulation with mirror symmetry
%  set up BEM solver
bem = bemsolver( p1, op1 );

%  plane wave excitations
exc1 = planewave( [ 0, 1, 0 ], [ 0, 0, 1 ], op1 );
exc2 = planewave( [ 0, 1, 0 ], [ 0, 0, 1 ], op2 );
%  light wavelength in vacuum
enei = 575;
%  surface charge
sig = bem \ exc1( p1, enei );

%  expand surface charge to full particle
[ sig2, p2 ] = full( sig );

%%  electric field enhancement w/o mirror symmetry
%  mesh for calculation of electric field
[ x, z ] = meshgrid( linspace( - 20, 20, 61 ), linspace( - 15, 15, 81 ) );
%  object for electric field
%    MINDIST controls the minimal distance of the field points to the
%    particle boundary, through NMAX it is possible to compute the electric
%    fields in portions and to work with less computer memory
emesh = meshfield( p2, x, 0, z, op2, 'mindist', 0.2, 'nmax', 2000 );
%  induced and incoming electric field
e = emesh( sig2 ) + emesh( exc2.field( emesh.pt, enei ) );
%  norm of electric field
ee = sqrt( dot( e, e, 3 ) );

%%  final plot
%  plot electric field
imagesc( x( : ), z( : ), ee );  

colorbar;  colormap hot( 255 );

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );

set( gca, 'YDir', 'norm' );
