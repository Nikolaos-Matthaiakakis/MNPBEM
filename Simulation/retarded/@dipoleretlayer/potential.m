function exc = potential( obj, p, enei )
%  POTENTIAL - Potential of dipole excitation for use in bemretlayer.
%
%  Usage for obj = dipoleretlayer :
%    exc = potential( obj, p, enei )
%  Input
%    p          :  particle surface where potential is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct array which contains the scalar and vector
%                  potentials, the last two dimensions of the exc fields
%                  correspond to the positions and dipole moments

%  wavenumber of light in vacuum
k0 = 2 * pi / enei;
%  direct excitation
exc = potential( obj.dip, p, enei );

%  find particle positions connected to layer structure
ind1 = any( bsxfun( @eq, p.expand( p.inout( :, 2 ) ) .', obj.layer.ind ), 2 );
%  positions of particle surface where potential is computed
pos1 = p.pos( ind1, : );

%  dipole positions and dipole moments
[ pt, dip ] = deal( obj.dip.pt, obj.dip.dip );
%  find dipole positions connected to layer structure
ind2 = any( bsxfun( @eq, pt.expand( pt.inout ), obj.layer.ind ), 2 );
%  positions of dipoles
pos2 = pt.pos( ind2, : );
%  dielectric function of media where dipoles are embedded
eps2 = pt.eps2( enei );  eps2 = eps2( ind2 );

%  evaluate Green function table
obj.tab = eval( obj.tab, enei );
%  Green functions and derivatives 
[ G, F ] = greenderiv( obj, pos1, pos2 );

%  dipole moment reduced by dielectric function
dip2 = matmul( diag( 1 ./ eps2 ), dip );
     
%%  potentials
%  vector potential
a1 = - 1i * k0 * fun(         G.p,  dip(  ind2, 1, : ) );
a2 = - 1i * k0 * fun(         G.p,  dip(  ind2, 2, : ) );
a3 = - 1i * k0 * fun(         G.hh, dip(  ind2, 3, : ) )  ...
               + fun( F{ 1, 2 }.hs, dip2( ind2, 1, : ) )  ...
               + fun( F{ 1, 3 }.hs, dip2( ind2, 2, : ) )  ...
               + fun( F{ 1, 4 }.hs, dip2( ind2, 3, : ) );
%  scalar potential
phi =          + fun( F{ 1, 2 }.ss, dip2( ind2, 1, : ) )  ...
               + fun( F{ 1, 3 }.ss, dip2( ind2, 2, : ) )  ...
               + fun( F{ 1, 4 }.ss, dip2( ind2, 3, : ) )  ...
     - 1i * k0 * fun(         G.sh, dip(  ind2, 3, : ) );
   
%  size of vector potential
siz = size( exc.a2( ind1, 1, ind2, : ) );
%  add to vector potential for direct excitation
exc.a2( ind1, 1, ind2, : ) = exc.a2( ind1, 1, ind2, : ) + reshape( a1, siz );
exc.a2( ind1, 2, ind2, : ) = exc.a2( ind1, 2, ind2, : ) + reshape( a2, siz );
exc.a2( ind1, 3, ind2, : ) = exc.a2( ind1, 3, ind2, : ) + reshape( a3, siz );
%  add to scalar potential for direct excitation
exc.phi2( ind1, ind2, : ) = exc.phi2( ind1, ind2, : ) + phi;

%%  surface derivatives of potentials
%  normal vector
nvec = p.nvec;
%  derivative operator
deriv = @( name, i )   ...
     bsxfun( @times, F{ 2, i }.( name ), nvec( :, 1 ) ) +  ...
     bsxfun( @times, F{ 3, i }.( name ), nvec( :, 2 ) ) +  ...
     bsxfun( @times, F{ 4, i }.( name ), nvec( :, 3 ) );
%  vector potential
a1p = - 1i * k0 * fun( deriv( 'p',  1 ), dip(  ind2, 1, : ) );
a2p = - 1i * k0 * fun( deriv( 'p',  1 ), dip(  ind2, 2, : ) );
a3p = - 1i * k0 * fun( deriv( 'hh', 1 ), dip(  ind2, 2, : ) )  ...
                + fun( deriv( 'hs', 2 ), dip2( ind2, 1, : ) )  ...
                + fun( deriv( 'hs', 3 ), dip2( ind2, 2, : ) )  ...
                + fun( deriv( 'hs', 4 ), dip2( ind2, 3, : ) );
%  scalar potential
phip =          + fun( deriv( 'ss', 2 ), dip2( ind2, 1, : ) )  ...
                + fun( deriv( 'ss', 3 ), dip2( ind2, 2, : ) )  ...
                + fun( deriv( 'ss', 4 ), dip2( ind2, 3, : ) )  ...
      - 1i * k0 * fun( deriv( 'sh', 1 ), dip(  ind2, 3, : ) );
   
%  add to surface derivative of vector potential for direct excitation
exc.a2p( ind1, 1, ind2, : ) = exc.a2p( ind1, 1, ind2, : ) + reshape( a1p, siz );
exc.a2p( ind1, 2, ind2, : ) = exc.a2p( ind1, 2, ind2, : ) + reshape( a2p, siz );
exc.a2p( ind1, 3, ind2, : ) = exc.a2p( ind1, 3, ind2, : ) + reshape( a3p, siz );
%  add to surface derivative of scalar potential for direct excitation
exc.phi2p( ind1, ind2, : ) = exc.phi2p( ind1, ind2, : ) + phip;   


function y = fun( g, dip )
%  FUN - Multiplication function

%  size of matrices
siz1 = size(   g );
siz2 = size( dip );
%  set output
y = repmat( reshape(   g, [ siz1, 1 ] ), [ 1, 1, siz2( end ) ] ) .*  ...
    repmat( reshape( dip, [ 1, siz2( 1 ), siz2( end ) ] ), [ siz1( 1 ), 1, 1 ] );
