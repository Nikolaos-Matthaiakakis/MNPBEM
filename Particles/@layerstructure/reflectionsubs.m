function [ r, rz ] = reflectionsubs( obj, enei, kpar, pos )
%  REFLECTIONSUBS - Reflection coefficients for substrate.
%    Computes reflection / transmission coefficients for surface charges 
%    and currents (see also REFLECTION).
%
%  Usage for obj = layerstructure :
%    r = reflectionsubs( obj, enei, kpar, pos )
%  Input
%    enei   :  wavelength of light in vacuum
%    kpar   :  parallel wavevector
%    pos    :  position structure
%  Output
%    r      :  structure with reflection and transmission coefficients
%    rz     :  derivative of R wrt z-value

%  dielectric functions and wavenumbers in media
[ eps, k ] = cellfun( @( eps ) ( eps( enei ) ), obj.eps );
%  z-component of wavevector
kz = sqrt( k .^ 2 - kpar ^ 2 );
kz = kz .* sign( imag( kz + 1e-10i ) );

%  dielectric functions and wavenumbers in media
%  note that eps1 (eps2) label the medium above (below) the interface
[ eps1, k1z ] = deal( eps( 1 ), kz( 1 ) );
[ eps2, k2z ] = deal( eps( 2 ), kz( 2 ) );

% parallel surface current
rr = ( k1z - k2z ) ./ ( k2z + k1z );
%  reflection and transmission matrix
r.p = [ rr, 1 + rr; 1 - rr, - rr ];

%  wavenumber of light in vacuum
k0 = 2 * pi / enei;
%  auxiliary quantity
Delta = ( k2z + k1z ) .* ( eps1 * k2z + eps2 * k1z );

%  reflection and transmission matrix
%  for the mixed contributions sh and hs there are no external potentials
mat1 = @( r1, r2 ) [ r1,   k1z / k2z * ( r2 + 1 ); k2z / k1z * ( r1 + 1 ),   r2 ];
mat2 = @( r1, r2 ) [ r1, - k1z / k2z *   r2      ; k2z / k1z *   r1      , - r2 ];


%  induced surface charge, from surface charge source
r.ss = mat1( ( k1z + k2z ) .* ( 2 * eps1 * k1z - eps2 * k1z - eps1 * k2z ) ./ Delta,  ...
             ( k2z + k1z ) .* ( 2 * eps2 * k2z - eps1 * k2z - eps2 * k1z ) ./ Delta );
%  induced surface current, from surface charge source
r.hs = mat2( - 2 * k0 * ( eps2 - eps1 ) * eps1 * k1z ./ Delta,  ...
             - 2 * k0 * ( eps1 - eps2 ) * eps2 * k2z ./ Delta );
          
%  induced surface charge, from surface current source
r.sh = mat2( - 2 * k0 * ( eps2 - eps1 ) * k1z ./ Delta,  ...
             - 2 * k0 * ( eps1 - eps2 ) * k2z ./ Delta );
%  induced surface current, from surface charge source
r.hh = mat1( ( k1z - k2z ) .* ( 2 * eps1 * k1z - eps2 * k1z + eps1 * k2z ) ./ Delta,  ...
             ( k2z - k1z ) .* ( 2 * eps2 * k2z - eps1 * k2z + eps2 * k1z ) ./ Delta );
          
%  Green functions
ind1 = pos.ind1;  g1 = exp( 1i * kz( ind1 ) .* abs( pos.z1( : ) .' - obj.z ) );  
ind2 = pos.ind2;  g2 = exp( 1i * kz( ind2 ) .* abs( pos.z2( : ) .' - obj.z ) );
%  derivative of Green function wrt z-value
g1z = g1 .* sign( pos.z1( : ) .' - obj.z );
%  get field names
names = fieldnames( r );

%  loop over field names
for i = 1 : length( names )
  %  get reflection and transmission coeffient
  rr = r.( names{ i } );
  
  if all( size( ind1 ) == size( ind2 ) )
    r.(  names{ i } ) = g1  .* rr( sub2ind( size( rr ), ind1, ind2 ) ) .* g2;
    rz.( names{ i } ) = g1z .* rr( sub2ind( size( rr ), ind1, ind2 ) ) .* g2;
  else
    r.(  names{ i } ) = rr( ind1, ind2 ) .* ( g1(  : ) * g2( : ) .' );
    rz.( names{ i } ) = rr( ind1, ind2 ) .* ( g1z( : ) * g2( : ) .' );
  end   
end
