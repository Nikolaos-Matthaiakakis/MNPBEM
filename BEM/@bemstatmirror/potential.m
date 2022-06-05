function pot = potential( obj, sig, varargin )
%  POTENTIAL - Potentials and surface derivatives inside/outside of particle.
%    Computed from solutions of Maxwell equations within the
%    quasistatic approximation.
%
%  Usage for obj = bemstatmirror :
%    pot = potential( obj, sig, inout )
%  Input
%    sig        :  COMPSTRUCTMIRROR object with surface charges
%    inout      :  potentials inside (inout = 1) or
%                            outside (inout = 2, default) of particle
%  Output
%    pot        :  COMPSTRUCTMIRROR object with potentials

if ~exist( 'inout', 'var' ),  inout = 2;  end
%  field from Green function
pot = obj.g.potential( sig, inout );
