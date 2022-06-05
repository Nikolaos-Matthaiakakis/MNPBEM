function [ sig, obj ] = mldivide( obj, exc )
%  Surface charges and currents for given excitation.
%
%  Usage for obj = bemretlayeriter :
%    [ sig, obj ] = obj \ exc
%  Input
%    exc    :  compstruct with fields for external excitation
%  Output
%    sig    :  compstruct with fields for surface charges and currents

[ sig, obj ] = solve( obj, exc );