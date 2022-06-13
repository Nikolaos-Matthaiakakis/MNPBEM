%  DEMOSPECSTAT4 - Field enhancement for coated metallic sphere.
%    We consider a glass sphere with a diameter of 10 nm coated by a 2 nm
%    thick silver layer.  For an incoming plane wave, this program first
%    computes within the quasistatic approximation the surface charge at
%    the resonance wavelength of 527 nm, and then the electric fields
%    outside and inside the nanoparticle.
%
%  Runtime on my computer:  8.3 sec.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' );
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'silver.dat' ), epsconst( 2.25 ) };

%  diameter of sphere
diameter = [ 10, 12 ];
%  initialize spheres
p = trisphere( 256, 1 );
%  set up COMPARTICLE objects
p = comparticle( epstab, { scale( p, diameter( 1 ) ),  ...
                           scale( p, diameter( 2 ) ) }, [ 3, 2; 2, 1 ], 1, 2, op );

%%  BEM simulation                         
%  set up BEM solvers
bem = bemsolver( p, op );
%  plane wave excitation
exc = planewave( [ 1, 0, 0 ], [ 0, 0, 1 ], op );
%  light wavelength in vacuum
enei = 527;
%  surface charge
sig = bem \ exc( p, enei );

%%  computation of electric field
%  mesh for calculation of electric field
[ x, z ] = meshgrid( linspace( - 10, 10, 81 ) );
%  object for electric field
%    MINDIST controls the minimal distance of the field points to the
%    particle boundary
emesh = meshfield( p, x, 0, z, op, 'mindist', 0.1 );
%  induced and incoming electric field
e = emesh( sig ) + emesh( exc.field( emesh.pt, enei ) );
%  norm of electric field
ee = sqrt( dot( e, e, 3 ) );

%%  final plot
%  plot electric field
imagesc( x( : ), z( : ), ee ); 

colorbar;  colormap hot( 255 );

xlabel( 'x (nm)' );
ylabel( 'z (nm)' );

set( gca, 'YDir', 'norm' );
axis equal tight
