function obj = init( obj )
%  Initialize Drude dielectric function.

%  atomic units
hartree = 27.2116;              %  2 * Rydberg in eV
tunit = 0.66 / hartree;         %  time unit in fs

switch obj.name
  case { 'Au', 'gold' }
    rs = 3;                     %  electron gas parameter
    obj.eps0 = 10;              %  background dielectric constant
    gammad = tunit / 10;        %  Drude relaxation rate
  case { 'Ag', 'silver' }
    rs = 3;
    obj.eps0 = 3.3;
    gammad = tunit / 30;
  case { 'Al', 'aluminum' }
    rs = 2.07;
    obj.eps0 = 1;
    gammad = 1.06 / hartree;
  otherwise
    error( 'Material name unknown' );
end

%  density in atomic units
density = 3 / ( 4 * pi * rs ^ 3 );
%  plasmon energy
wp = sqrt( 4 * pi * density );

%  save values
obj.gammad = gammad * hartree;
obj.wp     = wp     * hartree;

    
