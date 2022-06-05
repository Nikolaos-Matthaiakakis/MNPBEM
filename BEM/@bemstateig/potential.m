function pot = potential( obj, sig, inout )
%  Determine potentials and surface derivatives inside/outside of particle.
%    Computed from solutions of Maxwell equations within the
%    quasistatic approximation using an eigenmode expansion.
%
%  Usage for obj = bemstateig :
%    pot = potential( obj, sig, inout )
%  Input
%    sig        :  compstruct with surface charges (see bemstateig/mldivide)
%    inout      :  electric field inside (inout = 1) or
%                                outside (inout = 2, default) of particle
%  Output
%    pot        :  compstruct object with potentials

if ~exist( 'inout', 'var' ),  inout = 2;  end
%  compute potential
pot = obj.g.potential( sig, inout );