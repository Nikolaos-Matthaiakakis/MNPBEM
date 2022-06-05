function [ sca, dsca ] = scattering( obj, sig )
%  SCATTERING - Scattering cross section for scattered fields.
%
%  Usage for obj = spectrumstat :
%    [ sca, dsca ] = scattering( obj, sig )
%  Input
%    sig        :  compstruct object containing surface charges
%  Output
%     sca       :  scattering cross section
%    dsca       :  differential cross section

[ sca, dsca ] = scattering( farfield( obj, sig ) );
