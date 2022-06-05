function [ sca, dsca ] = scattering( obj, sig )
%  SCATTERING - Scattering cross section for plane wave excitation.
%
%  Usage for obj = planewaveret :
%    [ sca, dsca ] = scattering( obj, sig )
%  Input
%    sig        :  compstruct object containing surface currents
%  Output
%     sca       :  scattering cross section
%    dsca       :  differential cross section

%  total and differential radiated power
[ sca, dsca ] = scattering( obj.spec, sig );

%  refractive index of embedding medium
nb = sqrt( sig.p.eps{ 1 }( sig.enei ) );
%  The scattering cross section is the radiated power normalized to the
%  incoming power, the latter being proportional to 0.5 * epsb * (clight / nb)
[ sca, dsca.dsca ] = deal( sca / ( 0.5 * nb ), dsca.dsca / ( 0.5 * nb ) );
