function [ e, k ] = efresnel( obj, pol, dir, enei )
%  EFRESNEL - Reflected and transmitted electric fields.
%    For a plane wave excitation, EFRESNEL computes the electric fields
%    reflected or transmitted at the entire layer structure.
%
%  Usage for obj = layerstructure :
%    [ e, k ] = efresnel( obj, pol, dir, enei )
%  Input
%    pol    :  polarization vector
%    dir    :  light propagation direction
%    enei   :  wavelength of light in vacuum
%  Output
%    e      :  structure with reflected and transmitted electric fields
%    k      :  wavevectors for reflection and transmission

%  wavenumber of light in vacuum
k0 = 2 * pi / enei;
%  wavenumber in media
[ ~, k ] = cellfun( @( eps ) ( eps( enei ) ), obj.eps );

%  upper and lower layers
[ z1, ind1 ] = deal( obj.z( 1   ) + 1e-10, 1                  );
[ z2, ind2 ] = deal( obj.z( end ) - 1e-10, 1 + numel( obj.z ) );
%  allocate output arrays
[ ei, er, et ] = deal( zeros( size( pol ) ) );
[ ki, kr, kt ] = deal( zeros( size( pol ) ) );

%  loop over propagation directions
for i = 1 : size( pol, 1 )
  
  %  position structures for reflection and transmission
  if dir( i, 3 ) < 0
    %  excitation through upper medium
    posr = struct( 'r', 0, 'z1', z1, 'ind1', ind1, 'z2', z1, 'ind2', ind1 );
    post = struct( 'r', 0, 'z1', z2, 'ind1', ind2, 'z2', z1, 'ind2', ind1 );
  else
    %  excitation through lower medium
    posr = struct( 'r', 0, 'z1', z2, 'ind1', ind2, 'z2', z2, 'ind2', ind2 );
    post = struct( 'r', 0, 'z1', z1, 'ind1', ind1, 'z2', z2, 'ind2', ind2 );
  end
  
  %  parallel component of wavevector
  kpar = k( post.ind2 ) * dir( i, 1 : 2 );
  %  perpendicular components of reflected and transmitted waves
  kzr = sqrt( k( posr.ind1 ) ^ 2 - dot( kpar, kpar ) );  kzr = kzr .* sign( imag( kzr + 1e-10i ) );
  kzt = sqrt( k( post.ind1 ) ^ 2 - dot( kpar, kpar ) );  kzt = kzt .* sign( imag( kzt + 1e-10i ) );
  %  wavevectors for incident, reflected, and transmitted waves
  ki( i, : ) = [ kpar,   sign( dir( i, 3 ) ) * kzr ];
  kr( i, : ) = [ kpar, - sign( dir( i, 3 ) ) * kzr ];
  kt( i, : ) = [ kpar,   sign( dir( i, 3 ) ) * kzt ];
  
  %  reflection and transmission coefficients
  r = fresnel( obj, enei, norm( kpar ), posr );
  t = fresnel( obj, enei, norm( kpar ), post );
  %  incoming electric field
  ei( i, : ) = pol( i, : );
  %  reflected and transmitted electric field, 1i * k0 * A - grad V
  er( i, : ) = [ r.p * pol( i, 1 : 2 ), r.hh * pol( i, 3 ) ] - kr( i, : ) / k0 * r.sh * pol( i, 3 );
  et( i, : ) = [ t.p * pol( i, 1 : 2 ), t.hh * pol( i, 3 ) ] - kt( i, : ) / k0 * t.sh * pol( i, 3 );
  %  add phase factors 
  er( i, : ) = exp( - 1i * kr( i, 3 ) * posr.z2 - 1i * kr( i, 3 ) * posr.z1 ) * er( i, : );
  et( i, : ) = exp( - 1i * kr( i, 3 ) * post.z2 - 1i * kt( i, 3 ) * post.z1 ) * et( i, : );
end

%  set output arrays
e = struct( 'i', ei, 'r', er, 't', et );
k = struct( 'i', ki, 'r', kr, 't', kt );
