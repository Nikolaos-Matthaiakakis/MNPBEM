%  DEMODIPSTAT11 - Lifetime reduction for dipole between sphere and layer.
%    For a metallic nanosphere with a diameter of 4 nm located 1 nm above a
%    substrate and a dipole located between sphere and layer, this program
%    computes the total dipole scattering rates within the quasistatic
%    approximation.  We first compute the LDOS using the BEMSTATLAYER
%    solver.  Second, we model the substrate through an additional particle
%    of sufficient size.  To speed up the simulation, we exploit mirror
%    symmetry and use the BEMSTATMIRROR solver.
%
%  Runtime on my computer:  43 sec.

%%  initialization
%  table of dielectric functions
epstab = { epsconst( 1 ), epstable( 'gold.dat' ), epsconst( 2.25 ) }; 
%  location of interface of substrate
ztab = 0;

%  set up layer structure
layer = layerstructure( epstab, [ 1, 3 ], ztab );
%  options for BEM simulation with substrate
op1 = bemoptions( 'sim', 'stat', 'interp', 'curv', 'layer', layer );
%  options for BEM simulation, set SYM keyword
op2 = bemoptions( 'sim', 'stat', 'interp', 'curv', 'sym', 'xy' );

%%  particle without symmetry
%  nanosphere with finer discretization at the bottom
p = flip( trispheresegment( 2 * pi * linspace( 0, 1, 31 ),  ...
                                pi * linspace( 0, 1, 31 ) .^ 2, 4 ), 3 );
%  set up COMPARTICLE object, place sphere 1 nm above substrate
p1 = comparticle( epstab, { shift( p, [ 0, 0, 3 ] ) }, [ 2, 1 ], 1, op1 );

%%  particle with mirror symmetry
%  nanosphere with finer discretization at the bottom
p = flip( trispheresegment( 0.5 * pi * linspace( 0, 1, 11 ),  ...
                                  pi * linspace( 0, 1, 31 ) .^ 2, 4 ), 3 );
                 
%  polygon for plater
poly = polygon3( polygon( 30, 'size', [ 15, 15 ] ), 0 );
%  refine function
refun = @( pos, d ) 0.1 + 0.3 * sqrt( pos( :, 1 ) .^ 2 + pos( :, 2 ) .^ 2 );
%  plate below nanosphere
subs = plate( poly, op2, 'refun', refun );

%  set up COMPARTICLEMIRROR object
p2 = comparticlemirror( epstab, { shift( p, [ 0, 0, 3 ] ), subs },  ...
                                                [ 2, 1; 3, 1 ], 1, op2 );

%%  dipole oscillator
enei = linspace( 400, 800, 40 );
%  position of dipole
pt = compoint( p1, [ 0, 0, 0.5 ], op1 );
%  dipole excitation with and w/o explicit consideration of substrate
dip1 = dipole( pt, [ 1, 0, 0; 0, 0, 1 ], op1 );
dip2 = dipole( pt, [ 1, 0, 0; 0, 0, 1 ], op2 );

%  initialize total and radiative scattering rate
[ tot1, rad1 ] = deal( zeros( numel( enei ), 2 ) );
[ tot2, rad2 ] = deal( zeros( numel( enei ), 2 ) );

%%  BEM simulation
%  set up BEM solvers
bem1 = bemsolver( p1, op1 );
bem2 = bemsolver( p2, op2 );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charge
  sig1 = bem1 \ dip1( p1, enei( ien ) );
  sig2 = bem2 \ dip2( p2, enei( ien ) );
  %  total and radiative decay rate
  [ tot1( ien, : ), rad1( ien, : ) ] = dip1.decayrate( sig1 );
  [ tot2( ien, : ), rad2( ien, : ) ] = dip2.decayrate( sig2 );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final plot
plot( enei, tot1, 'o-'   ); hold on;
if ~verLessThan( 'matlab', '8.4.0' ), set( gca, 'ColorOrderIndex', 1 );  end
plot( enei, tot2, '.-'  ); 

xlabel( 'Wavelength (nm)' );
ylabel( 'Total decay rate' );

legend( 'x-dip, with subs', 'z-dip, with subs',  ...
        'x-dip, w/o  subs', 'z-dip, w/o  subs' );
