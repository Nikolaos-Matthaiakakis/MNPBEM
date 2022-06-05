function [ sig, obj ] = mldivide( obj, exc )
%  Surface charge for given excitation.
%
%  Usage for obj = bemstat :
%    [ sig, obj ] = obj \ exc
%  Input
%    exc    :  compstruct with field 'phip' for external excitation
%  Output
%    sig    :  compstruct with field for surface charge

[ sig, obj ] = solve( obj, exc );
