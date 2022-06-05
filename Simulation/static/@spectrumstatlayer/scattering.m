function [ sca, dsca ] = scattering( obj, dip, enei )
%  SCATTERING - Scattering cross section for scattered fields.
%
%  Usage for obj = spectrumstatlayer :
%    [ sca, dsca ] = scattering( obj, dip, enei )
%  Input
%    dip        :  dipole moments, must be located above substrate
%    enei       :  
%  Output
%     sca       :  scattering cross section
%    dsca       :  differential cross section

%  electric farfields
[ field, k ] = efarfield( obj, dip, enei );
%  wavenumber of light in vacuum
k0 = 2 * pi / enei;

%  differerential radiated power, Jackson Eq. (9.22)
dsca = squeeze( sum( abs( field ) .^ 2, 2 ) );
%  multiply with 0.5 * nb
dsca = reshape( bsxfun( @times, dsca( :, : ), 0.5 * k( : ) / k0 ), size( dsca ) );
%  damp fields in media with complex dielectric functions
dsca( imag( dsca ) ~= 0 ) = 0;

%  index for total cross section
if isempty( obj.medium )
  ind = 1 : size( dsca, 1 );
else
  if obj.medium == obj.layer.ind( 1 );
    ind = obj.pinfty.pos( :, 3 ) > 0;
  elseif obj.medium == obj.layer.ind( end );
    ind = obj.pinfty.pos( :, 3 ) < 0;
  end
end

%  area of unit sphere
area = accumarray( [ 0 * ind( : ) + 1, ind( : ) ],  ...
                           obj.pinfty.area( ind ), [ 1, obj.pinfty.n ] );
%  total cross section
sca = matmul( area, dsca );
%  differential cross section
dsca = compstruct( obj.pinfty, enei, 'dsca', dsca );
