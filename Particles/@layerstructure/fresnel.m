function r = fresnel( obj, enei, kpar, pos )
%  FRESNEL - Fresnel reflection and transmission coefficients for potentials.
%
%  Usage for obj = layerstructure :
%    r = fresnel( obj, enei, kpar, pos )
%  Input
%    enei   :  wavelength of light in vacuum
%    kpar   :  parallel wavevector
%    pos    :  position structure
%  Output
%    r      :  structure with reflection and transmission coefficients

%  wavenumber in media
[ ~, k ] = cellfun( @( eps ) ( eps( enei ) ), obj.eps );
%  perpendicular component of wavevector
kz = sqrt( k .^ 2 - kpar ^ 2 ) + 1e-10i;  kz = kz .* sign( imag( kz ) );

%  perpendicular components of wavevector
k1z = kz( pos.ind1 );
k2z = kz( pos.ind2 );
%  ratio of z-component of wavevector
if all( size( pos.z1 ) == size( pos.z2 ) )
  ratio = k2z ./ k1z;
else
  ratio = bsxfun( @times, 1 ./ k1z( : ), k2z( : ) .' );
end

%  reflection and transmission coefficients 
r = reflection( obj, enei, kpar, pos );
%  get field names
names = fieldnames( r );
%  loop over field names
for i = 1 : length( names )
  %  correct reflection coefficients
  %    REFLECTION uses as sources the surface charges and currents, whereas
  %    FRESNEL    uses as sources the scalar and vector potentials
  r.( names{ i } ) = r.( names{ i } ) .* ratio;
end
