function [ G, Fr, Fz, r, zmin ] = interp3( obj, r, z1, z2 )
%  INTERP3 - Interpolate tabulated 3d Green functions.
%
%  Usage for obj = greentablayer :
%    [ G, Fr, Fz, r, zmin ] = interp3( obj, r, z1, z2 )
%  Input
%    r       :  radii
%    z1, z2  :  z-distances
%  Output
%    G       :  Green function
%    Fr      :  derivative of Green function along radius
%    Fz      :  derivative of Green function along z
%    r       :  radius as used in interpolation
%    zmin    :  minimal distance to layers as used in interpolation

%  round radii and z-values
r = max( obj.layer.rmin, r );  [ z1, z2 ] = round( obj.layer, z1, z2 );
%  minimum distance to layer 
zmin = mindist( obj.layer, z1 ) + mindist( obj.layer, z2 );
%  distance 
d  = sqrt( r .^ 2 + zmin .^ 2 );

%  bilinear interpolation function
fun = finterp( igrid3( obj.r, obj.z1,obj.z2 ), r, z1, z2 );
%  multiply tabulated Green function with distance-dependent factors
[ g, fr, fz ] = norm( obj );
%  get field names
names = fieldnames( obj.G );

%  loop over field names
for i = 1 : length( names )
  %  Green function, for interpolation see 
  %    Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015), Eq. (15).
  G.( names{ i } ) = fun( g.( names{ i } ) ) ./ d;
  %  radial and z-derivative of Green function
  Fr.( names{ i } ) = fun( fr.( names{ i } ) ) .*    r ./ d .^ 3;
  Fz.( names{ i } ) = fun( fz.( names{ i } ) ) .* zmin ./ d .^ 3;
end
