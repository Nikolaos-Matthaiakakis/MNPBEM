function pot = potential( obj, sig, inout )
%  Determine potentials and surface derivatives inside/outside of particle.
%    Computed from solutions of Maxwell equations within the
%    quasistatic approximation.
%
%  Usage for obj = bemstatlayer :
%    pot = potential( obj, sig, inout )
%  Input
%    sig        :  compstruct object with surface charges
%    inout      :  potential inside (inout = 1, default) or
%                           outside (inout = 2) of particle
%  Output
%    pot        :  COMPSTRUCT object with potentials

if ~exist( 'inout', 'var' ),  inout = 2;  end
%  compute potential
pot = obj.g.potential( sig, inout );