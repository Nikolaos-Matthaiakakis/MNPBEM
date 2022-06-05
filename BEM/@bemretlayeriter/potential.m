function pot = potential( obj, sig, inout )
%  Potentials and surface derivatives inside/outside of particle.
%
%  Usage for obj = bemretlayeriter :
%    pot = potential( obj, sig, inout )
%  Input
%    sig        :  compstruct with surface charges
%    inout      :  potential inside (inout = 1) or
%                           outside (inout = 2, default) of particle
%  Output
%    pot        :  compstruct object with potentials

if ~exist( 'inout', 'var' ),  inout = 2;  end
%  compute potential
pot = obj.g.potential( sig, inout );
