function [ sca, dsca ] = scattering( obj, sig )
%  SCATTERING - Scattering cross section for dipole excitation.
%
%  Usage for obj = dipoleretmirror :
%    [ sca, dsca ] = scattering( obj, sig )
%  Input
%    sig        :  compstruct object containing surface charges and currents
%  Output
%     sca       :  scattering cross section
%    dsca       :  differential cross section

[ sca, dsca ] = scattering( obj.dip, full( obj, sig ) );
