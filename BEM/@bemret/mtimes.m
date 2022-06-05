function phi = mtimes( obj, sig )
%  Induced potential for given surface charge.
%
%  Usage for obj = bemret :
%    phi = obj * sig
%  Input
%    sig    :  compstruct with fields for surface charges and currents
%  Output
%    phi    :  compstruct with fields for induced potential

phi = potential( obj, sig, 1 ) + potential( obj, sig, 2 );