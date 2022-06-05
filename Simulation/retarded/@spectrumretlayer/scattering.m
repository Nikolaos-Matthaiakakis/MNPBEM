function [ sca, dsca ] = scattering( obj, sig )
%  SCATTERING - Scattering cross section for scattered fields.
%
%  Usage for obj = spectrumretlayer :
%    [ sca, dsca ] = scattering( obj, sig )
%  Input
%    sig        :  compstruct object containing surface currents
%  Output
%     sca       :  scattering cross section
%    dsca       :  differential cross section

[ sca, dsca ] = scattering( farfield( obj, sig ), obj.medium );
