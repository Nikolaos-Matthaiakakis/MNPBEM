function phi = mtimes( obj, sig )
%  Induced potential for given surface charge.
%
%  Usage for obj = bemstateig :
%    phi = obj * sig
%  Input
%    sig    :  compstruct with fields for surface charge
%  Output
%    phi    :  compstruct with fields for induced potential

phi  = potential( obj, sig, 1 );
phi2 = potential( obj, sig, 2 );

phi.phi2p = phi2.phi2p;
