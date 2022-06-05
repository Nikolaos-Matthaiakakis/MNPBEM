function field = field( obj, sig, inout )
%  Electromagnetic fields inside or outside of particle surface.
%    Computed from solutions of Maxwell equations within the
%    quasistatic approximation.
%
%  Usage for obj = bemstateigmirror :
%    field = field( obj, sig, inout )
%  Input
%    sig        :  COMPSTRUCTMIRROR object with surface charges
%    inout      :  electric field inside (inout = 1) or
%                                outside (inout = 2, default) of particle
%  Output
%    field      :  COMPSTRUCTMIRROR object with electric field

if ~exist( 'inout', 'var' ),  inout = 2;  end
%  field from Green function
field = obj.g.field( sig, inout );