function field = field( obj, sig, inout )
%  Electric and magnetic field inside/outside of particle surface.
%    Computed from solutions of full Maxwell equations.
%
%  Usage for obj = bemretmirror :
%    field = field( obj, sig, inout )
%  Input
%    sig        :  surface charges
%    inout      :  electric field inside (inout = 1) or
%                                outside (inout = 2, default) of particle
%  Output
%    field      :  COMPSTRUCTMIRROR object with electric and magnetic fields

if ~exist( 'inout', 'var' ),  inout = 2;  end
%  field from Green function
field = obj.g.field( sig, inout );
