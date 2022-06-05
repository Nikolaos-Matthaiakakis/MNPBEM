%  DEMOSPECRET5 - Field enhancement for Au nanosphere in Ag nanocube.
%    For a Au nanosphere (diameter 35 nm) in a Ag nanocube (size 100 nm)
%    and an incoming plane wave with a polarization along x, this program
%    first computes the surface charge at the resonance wavelength of 470
%    nm, and then the electric fields outside and inside the nanoparticle.
%    For an experimental realization of the nanoparticle see
%    G. Boris et al., J. Chem. Phys. C 118, 15356 (2014).
%
%  Runtime on my computer:  53 sec.

%%  initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'ret', 'interp', 'curv', 'refine', 2 );

%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'silver.dat' ), epstable( 'gold.dat' ) };

%  nanosphere
p1 = trisphere( 144, 70 );
%  rounded nanocube
p2 = tricube( 12, 100 );

%  initialize gold sphere in silver cube
p = comparticle( epstab, { p1, p2 }, [ 3, 2; 2, 1 ], 1, 2, op );

%%  BEM simulation                         
%  set up BEM solvers
bem = bemsolver( p, op );
%  plane wave excitation
exc = planewave( [ 1, 0, 0 ], [ 0, 0, 1 ], op );
%  light wavelength in vacuum
enei = 470;
%  surface charge
sig = bem \ exc( p, enei );

%%  computation of electric field
%  mesh for calculation of electric field
[ x, z ] = meshgrid( linspace( - 70, 70, 81 ) );
%  object for electric field
%    MINDIST controls the minimal distance of the field points to the
%    particle boundary
emesh = meshfield( p, x, 0, z, op, 'mindist', 0.9, 'nmax', 2000 );
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
