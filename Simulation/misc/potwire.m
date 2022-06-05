function [ phi, phir, phiz ] = potwire( r, z, q, k, z0, z1 )
%  POTWIRE - Potential for charged wire.
%    Integrate[ Exp[ I q zz ] / Sqrt[ r ^ 2 + ( zz - z ) ^ 2 ], 
%                                             { zz, z1, z2 } ]
%
%  Usage :
%    [ phi, phir, phiz ] = potwire( r, z, q, z1, z2 )
%  Input
%    r      :  distance normal to electron beam
%    z      :  distance along electron beam
%    q      :  wavenumber of electron beam
%    k      :  wavenumber of light
%    z1     :  beginning of wire
%    z2     :  end of wire
%  Output
%    phi    :  potential
%    phir   :  derivative of potential wrt r
%    phiz   :  derivative of potential wrt z

%  in the solution of the integral we perform the following transformations
%    u = zz - z
%    v = log( u + sqrt( r ^ 2 + u ^ 2 )

%  adapt integration limits
z0 = repmat( reshape( z0, 1, [] ), size( r, 1 ), 1 ) - z;
z1 = repmat( reshape( z1, 1, [] ), size( r, 1 ), 1 ) - z;
%  transform integration limits
v0 = log( z0 + sqrt( r .^ 2 + z0 .^ 2 ) );
v1 = log( z1 + sqrt( r .^ 2 + z1 .^ 2 ) );

%  initialize integrals
[ phi, phir, phiz ] = deal( 0, 0, 0 );
%  positions and weights for integration
[ x, w ] = lglnodes( 10 );

%  loop over integration points
for i = 1 : length( x )
  %  transform integration variable to u
  v = 0.5 * ( ( 1 - x( i ) ) * v0 + ( 1 + x( i ) ) * v1 );
  u = 0.5 * ( exp( v ) - r .^ 2 .* exp( - v ) );
  %  distance
  rr = sqrt( r.^ 2 + u .^ 2 );
  %  exponential factor
  fac = exp( 1i * ( q * u + k * rr ) );
  %  integral and derivatives
  phi = phi + w( i ) * fac;
  phir = phir + w( i ) * r .* ( 1i * k ./ rr - 1 ./ rr .^ 2 ) .* fac;
  phiz = phiz - w( i ) * u .* ( 1i * k ./ rr - 1 ./ rr .^ 2 ) .* fac;
end
%  multiply with integration limits
phi  = 0.5 * ( v1 - v0 ) .* exp( 1i * q * z ) .* phi;
phir = 0.5 * ( v1 - v0 ) .* exp( 1i * q * z ) .* phir;
phiz = 0.5 * ( v1 - v0 ) .* exp( 1i * q * z ) .* phiz;
