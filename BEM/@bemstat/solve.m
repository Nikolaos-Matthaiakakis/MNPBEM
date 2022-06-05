function [ sig, obj ] = solve( obj, exc )
%  SOLVE - Solve BEM equations for given excitation.
%
%  Usage for obj = bemstat :
%    [ sig, obj ] = solve( obj, exc )
%  Input
%    exc    :  compstruct with fields for external excitation
%  Output
%    sig    :  compstruct with fields for surface charge

[ sig, obj ] = mldivide( obj, exc );