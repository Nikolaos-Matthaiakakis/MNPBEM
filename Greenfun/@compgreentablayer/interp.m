function [ G, Fr, Fz, ri, zi ] = interp( obj, r, z1, z2 )
%  INTERP - Interpolate tabulated Green functions.
%
%  Usage for obj = compgreentablayer :
%    [ G, Fr, Fz, r, zmin ] = interp( obj, r, z1, z2 )
%  Input
%    r       :  radii
%    z1, z2  :  z-distances
%  Output
%    G       :  Green function
%    Fr      :  derivative of Green function along radius
%    Fz      :  derivative of Green function along z
%    r       :  radius as used in interpolation
%    zmin    :  minimal distance to layers as used in interpolation
  
%  index to Green function to be used for interpolation
ind = inside( obj, r, z1, z2 );
%  make sure that all interpolation is possible for all positions
assert( ~any( ind == 0 ) );

names = fieldnames( obj.g{ 1 }.G );
%  allocate arrays
for i = 1 : length( names )
  G.(  names{ i } ) = zeros( size( r ) );
  Fr.( names{ i } ) = zeros( size( r ) );
  Fz.( names{ i } ) = zeros( size( r ) );
end
%  radii and minimal z-distance as used in interpolation
[ ri, zi ] = deal( zeros( size( r ) ), zeros( size( r ) ) );

%  loop over Green functions
for i = unique( reshape( ind, 1, [] ) )
  %  evaluate Green function 
  [ g, fr, fz, ri( ind == i ), zi( ind == i ) ] =  ...
      obj.g{ i }( r( ind == i ), z1( ind == i ), z2( ind == i ) );
  %  save Green function
  for j = 1 : length( names )
    G.(  names{ j } )( ind == i ) = g.(  names{ j } );
    Fr.( names{ j } )( ind == i ) = fr.( names{ j } );
    Fz.( names{ j } )( ind == i ) = fz.( names{ j } );
  end
end
