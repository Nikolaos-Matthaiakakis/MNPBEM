function [ sca, dsca ] = scattering( obj, sig )
%  SCATTERING - Scattering cross section for scattered fields.
%
%  Usage for obj = spectrumret :
%    [ sca, dsca ] = scattering( obj, sig )
%  Input
%    sig        :  compstruct object containing surface charges and currents
%  Output
%     sca       :  scattering cross section
%    dsca       :  differential cross section

[ sca, dsca ] = scattering( farfield( obj, sig ) );
