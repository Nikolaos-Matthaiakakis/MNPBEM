function exc = field( obj, p, enei, ~ )
%  Electromagnetic fields for EELS excitation.
%
%  Usage for obj = eelsstat :
%    exc = field( obj, p, enei )
%  Input
%    p          :  points or particle surface where field is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct object which contains the electric
%                  fields, the last dimension corresponding to the 
%                  impact parameters of the electron beam

%  dielectric functions and wavenumbers
[ eps, k ] = cellfun( @( eps ) ( eps( enei ) ), p.eps );
%  difference of inverse dielectric functions
ideps =  1 ./ eps - 1 / eps( 1 );
%  wavenumber of electron
q = k( 1 ) / ( obj.vel * sqrt( eps( 1 ) ) );

%  external excitation
exc = compstruct( p, enei );
%  electric fields
exc.e = fieldinfty(  obj, p.pos, q, k( 1 ), eps( 1 ) ) +  ...
        fieldinside( obj, p.pos, q, ideps );


function e = fieldinfty( obj, pos, q, ~, eps )
%  FIELDINFTY - Fields for infinite electron beam.
%    See F. J. Garcia de Abajo, Rev. Mod. Phys. 82, 209 (2010), Eqs. (5),
%    use quasistatic limit.

%  impact parameters and electron velocity
[ b, vel ] = deal( obj.impact, obj.vel );

%  lateral distance vector
x = bsxfun( @minus, repmat( pos( :, 1 ), 1, size( b, 1 ) ), b( :, 1 ) .' );
y = bsxfun( @minus, repmat( pos( :, 2 ), 1, size( b, 1 ) ), b( :, 2 ) .' );
%  parallel component
z = repmat( pos( :, 3 ), 1, size( b, 1 ) );

%  distance
rr = sqrt( x .^ 2 + y .^ 2 + obj.width ^ 2 );
%  unit vector
[ x, y ] = deal( x ./ rr, y ./ rr );

%  Bessel functions
K0 = besselk( 0, q * rr );
K1 = besselk( 1, q * rr );
%  prefactor
fac = 2 * q / vel * exp( 1i * q * z );

%  allocate array for electromagnetic fields
e = zeros( size( x, 1 ), 3, size( b, 1 ) );
%  electric field
e( :, 1, : ) =    - fac / eps .* K1 .* x;
e( :, 2, : ) =    - fac / eps .* K1 .* y;
e( :, 3, : ) = 1i * fac / eps .* K0;


function e = fieldinside( obj, pos, q, ideps )
%  FIELDINSIDE - Compute field of electron trajectories inside of particle.

%  impact parameters and electron velocity
[ b, vel ] = deal( obj.impact, obj.vel );

%  relative coordinates
x = bsxfun( @minus, repmat( pos( :, 1 ), 1, size( b, 1 ) ), b( :, 1 ) .' );
y = bsxfun( @minus, repmat( pos( :, 1 ), 1, size( b, 1 ) ), b( :, 2 ) .' );
z = repmat( pos( :, 3 ), 1, size( b, 1 ) );
%  coordinates perpednicular to electron beam
r  = sqrt( x .^ 2 + y .^ 2 );
rr = sqrt( r .^ 2 + obj.width .^ 2 );

%  potential
[ ~, Ir, Iz ] = potwire( rr, z, q, 0, obj.z( :, 1 ), obj.z( :, 2 ) );
%  expand differences of dielectric functions
ideps = ideps( obj.indmat );

%  allocate array for electric field
e = zeros( size( pos, 1 ), 3, size( b, 1 ) );
%  electric field
e( :, 1, : ) = bsxfun( @times, Ir, ideps ) / vel .* x ./ rr;
e( :, 2, : ) = bsxfun( @times, Ir, ideps ) / vel .* y ./ rr;
e( :, 3, : ) = bsxfun( @times, Iz, ideps ) / vel;

