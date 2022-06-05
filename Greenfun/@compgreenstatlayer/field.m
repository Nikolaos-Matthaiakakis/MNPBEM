function field = field( obj, sig, inout )
%  FIELD - Electric field inside/outside of particle surface.
%
%  Usage for obj = compgreenstatlayer :
%    field = field( obj, sig, inout )
%  Input
%    sig        :  compstruct with surface charges
%    inout      :  fields inside (inout = 1, default) or
%                        outside (inout = 2) of particle surface
%  Output
%    field      :  compstruct object with electric field

%  get distance and derivative of Green function
[ d, Gp ] = eval( obj, sig.enei, 'd', 'Gp' );

%  electric field at in- or outside
if ~exist( 'inout', 'var' ) || isempty( inout ) || inout == 1
  e = - matmul( Gp + 2 * pi * outer( obj.p1.nvec, d == 0 ), sig.sig );
else
  e = - matmul( Gp - 2 * pi * outer( obj.p1.nvec, d == 0 ), sig.sig );
end

%  set output
field = compstruct( obj.p1, sig.enei, 'e', e );
