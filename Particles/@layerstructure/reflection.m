function [ r, rz ] = reflection( obj, enei, kpar, pos )
%  REFLECTION - Reflection coefficients for surface charges and currents.
%    see Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015).
%
%  Usage for obj = layerstructure :
%    [ r, rz ] = reflection( obj, enei, kpar, pos )
%  Input
%    enei   :  wavelength of light in vacuum
%    kpar   :  parallel wavevector
%    pos    :  position structure
%  Output
%    r      :  structure with reflection and transmission coefficients
%    rz     :  derivative of R wrt z-value

%  use simpler equations for substrate in case of single interface
if length( obj.z ) == 1
  [ r, rz ] = reflectionsubs( obj, enei, kpar, pos );
  return
end

%  wavenumbers in media
[ ~, k ] = cellfun( @( eps ) ( eps( enei ) ), obj.eps );
%  perpendicular component of wavevector
kz = sqrt( k .^ 2 - kpar ^ 2 ) + 1e-10i;  kz = kz .* sign( imag( kz ) );

%  index to layers
ind1 = pos.ind1;
ind2 = pos.ind2;
%  perpendicular components of wavevectors in different media
k1z = kz( ind1 );
k2z = kz( ind2 );

%  distance to lower interfaces
dn1 = abs( pos.z1( : )' - subsref( [ obj.z, - 1e100 ], substruct( '()', { ind1 } ) ) );
dn2 = abs( pos.z2( : )' - subsref( [ obj.z, - 1e100 ], substruct( '()', { ind2 } ) ) );
%  distance to upper interfaces
up1 = abs( pos.z1( : )' - subsref( [ 1e100, obj.z ], substruct( '()', { ind1 } ) ) );
up2 = abs( pos.z2( : )' - subsref( [ 1e100, obj.z ], substruct( '()', { ind2 } ) ) );

%  size of excitation matrix
siz = [ 2 * numel( obj.z ) + 2, numel( ind2 ) ];
%  prefactor for Green function
fac = 2i * pi ./ k2z;
%  excitation
exc = accumarray( { 2 * ind2,     1 : numel( ind2 ) }, fac .* exp( 1i * k2z .* dn2 ), siz ) +  ...
      accumarray( { 2 * ind2 - 1, 1 : numel( ind2 ) }, fac .* exp( 1i * k2z .* up2 ), siz );
%  remove layers at infinity
exc = exc( 2 : end - 1, : );
    
%  matrices for solution of BEM equations
[ par, perp ] = bemsolve( obj, enei, kpar );


%%  parallel surface current
%  solve BEM equations
y = par * exc;
%  surface currents above and below interface, add layers at infinity
h1 = [ 0 * y( 1, : ); y( 2 : 2 : end, : ) ];
h2 = [                y( 1 : 2 : end, : ); 0 * y( 1, : ) ];

%  reflection and transmission coefficients
r .p = multiply( pos, h2, exp( 1i * k1z .* dn1 ) ) + multiply( pos, h1, exp( 1i * k1z .* up1 ) );
rz.p = multiply( pos, h2, exp( 1i * k1z .* dn1 ) ) - multiply( pos, h1, exp( 1i * k1z .* up1 ) );    
      
%%  surface charge
%  extend excitation matrix
exc2 = zeros( [ 2, 1 ] .* size( exc ) );
%  only surface excitations
exc2( 1 : 2 : end, : ) = exc;

%  solve BEM equations
y = perp * exc2;
%  surface charge above and below interface, add layers at infinity
sig1 = [ 0 * y( 1, : ); y( 3 : 4 : end, : ) ];
sig2 = [                y( 1 : 4 : end, : ); 0 * y( 1, : ) ];
%  reflection and transmission coefficients
r .ss = multiply( pos, sig2, exp( 1i * k1z .* dn1 ) ) + multiply( pos, sig1, exp( 1i * k1z .* up1 ) );
rz.ss = multiply( pos, sig2, exp( 1i * k1z .* dn1 ) ) - multiply( pos, sig1, exp( 1i * k1z .* up1 ) );     
      
%  surface currents above and below interface, add layers at infinity
h1 = [ 0 * y( 1, : ); y( 4 : 4 : end, : ) ];
h2 = [                y( 2 : 4 : end, : ); 0 * y( 1, : ) ];
%  reflection and transmission coefficients
r .hs = multiply( pos, h2, exp( 1i * k1z .* dn1 ) ) + multiply( pos, h1, exp( 1i * k1z .* up1 ) );
rz.hs = multiply( pos, h2, exp( 1i * k1z .* dn1 ) ) - multiply( pos, h1, exp( 1i * k1z .* up1 ) );     

%%  perpendicular surface current
%  extend excitation matrix
exc2 = zeros( [ 2, 1 ] .* size( exc ) );
%  only surface excitations
exc2( 2 : 2 : end, : ) = exc;

%  solve BEM equations
y = perp * exc2;
%  surface charge above and below interface, add layers at infinity
sig1 = [ 0 * y( 1, : ); y( 3 : 4 : end, : ) ];
sig2 = [                y( 1 : 4 : end, : ); 0 * y( 1, : ) ];
%  reflection and transmission coefficients
r .sh = multiply( pos, sig2, exp( 1i * k1z .* dn1 ) ) + multiply( pos, sig1, exp( 1i * k1z .* up1 ) );
rz.sh = multiply( pos, sig2, exp( 1i * k1z .* dn1 ) ) - multiply( pos, sig1, exp( 1i * k1z .* up1 ) );     
      
%  surface currents above and below interface, add layers at infinity
h1 = [ 0 * y( 1, : ); y( 4 : 4 : end, : ) ];
h2 = [                y( 2 : 4 : end, : ); 0 * y( 1, : ) ];
%  reflection and transmission coefficients
r .hh = multiply( pos, h2, exp( 1i * k1z .* dn1 ) ) + multiply( pos, h1, exp( 1i * k1z .* up1 ) );
rz.hh = multiply( pos, h2, exp( 1i * k1z .* dn1 ) ) - multiply( pos, h1, exp( 1i * k1z .* up1 ) );     

     
function c = multiply( pos, a, b )
%  MULTIPLY - Multiply a and b.
%    Depending on the size of a and b, either the direct product a .* b or
%    the outer product a * b is computed.
    
if all( size( pos.z1 ) == size( pos.z2 ) )
  c = a( sub2ind( size( a ), pos.ind1, 1 : size( a, 2 ) ) ) .* b;
else
 c = bsxfun( @times, a( pos.ind1, : ), b( : ) );
end
