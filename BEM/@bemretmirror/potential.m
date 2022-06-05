function pot = potential( obj, sig, inout )
%  Determine potentials and surface derivatives inside/outside of particle.
%    Computed from solutions of Maxwell equations.
%
%  Usage for obj = bemretmirror :
%    pot = potential( obj, sig, inout )
%  Input
%    sig        :  compstructmirror with surface charges and currents
%    inout      :  potentials inside (inout = 1) or
%                            outside (inout = 2, default) of particle
%  Output
%    pot        :  compstructmirror object with potentials

if ~exist( 'inout', 'var' ),  inout = 2;  end
%  field from Green function
pot = obj.g.potential( sig, inout );
