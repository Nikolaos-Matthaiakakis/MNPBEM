%  DEMOEELSSTAT1 - Comparison BEM and Mie for EELS of metallic nanosphere.
%    For a silver nanosphere of 30 nm, this program computes the energy
%    loss probability for an impact parameter of 5 nm and for different
%    loss energies within the quasistatic approximation, and compares the
%    results with Mie theory.
%
%  See also F. J. Garcia de Abajo, Rev. Mod. Phys. 82, 209 (2010), Eq. (31).
%
%  Runtime on my computer:  5.4 seconds.

%% initialization
%  options for BEM simulation
op = bemoptions( 'sim', 'stat', 'interp', 'curv' );
%  table of dielectric function
epstab = { epsconst( 1 ), epstable( 'silver.dat' ) };

%  diameter
diameter = 30;
%  nanosphere
p = comparticle( epstab, { trisphere( 144, diameter ) }, [ 2, 1 ], 1, op );

%  width of electron beam and electron velocity
[ width, vel ] = deal( 0.5, eelsbase.ene2vel( 200e3 ) );
%  impact parameter
imp = 5;
%  loss energies in eV
ene = linspace( 3, 4.5, 40 );

%  convert energies to nm
units;  enei = eV2nm ./ ene;

%%  BEM solution
%  BEM solver
bem = bemsolver( p, op );
%  electron beam excitation
exc = electronbeam( p, [ diameter / 2 + imp, 0 ], width, vel, op );
%  surface loss
psurf = zeros( size( ene ) );

multiWaitbar( 'BEM solver', 0, 'Color', 'g', 'CanCancel', 'on' );
%  loop over wavelengths
for ien = 1 : length( enei )
  %  surface charges
  sig = bem \ exc( enei( ien ) );
  %  EELS losses
  psurf( ien ) = exc.loss( sig );
  
  multiWaitbar( 'BEM solver', ien / numel( enei ) );
end
%  close waitbar
multiWaitbar( 'CloseAll' );

%%  final figure and comparison with Mie solution
%  Mie solver
mie = miesolver( epstab{ 2 }, epstab{ 1 }, diameter, op, 'lmax', 40 );
%  final plot
plot( ene, psurf, 'o-', ene, mie.loss( imp, enei, vel ), '.-' );

legend( 'BEM', 'Mie' );

xlabel( 'Loss energy (eV)' );
ylabel( 'Loss probability (eV^{-1})' );
