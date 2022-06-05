function [ sca, dsca ] = scattering( obj, sig )
%  SCATTERING - Scattering cross section for plane wave excitation.
%
%  Usage for obj = planewaveretlayer :
%    [ sca, dsca ] = scattering( obj, sig )
%  Input
%    sig        :  compstruct object containing surface currents
%  Output
%     sca       :  scattering cross section
%    dsca       :  differential cross section

[ sca, dsca ] = scattering( obj.spec, sig );

%  refractive indices
nb = sqrt( cellfun( @( eps ) eps( sig.enei ), obj.layer.eps ) );
%  light propagation direction
dir = obj.dir( :, 3 );
%  the scattering cross section is the radiated power normalized to the
%  incoming power, the latter being proportional to 0.5 * epsb * (clight / nb)
sca( dir < 0 ) = sca( dir < 0 ) / ( 0.5 * nb( 1   ) );
sca( dir > 0 ) = sca( dir > 0 ) / ( 0.5 * nb( end ) );
%  differential cross section
dsca.dsca( :, dir < 0 ) = dsca.dsca( :, dir < 0 ) / ( 0.5 * nb( 1   ) );
dsca.dsca( :, dir > 0 ) = dsca.dsca( :, dir > 0 ) / ( 0.5 * nb( end ) );
