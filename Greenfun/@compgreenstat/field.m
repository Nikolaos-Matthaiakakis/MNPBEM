function field = field( obj, sig, inout )
%  FIELD - Electric field inside/outside of particle surface.
%
%  Usage for obj = compgreenstat :
%    field = field( obj, sig, inout )
%  Input
%    sig        :  compstruct with surface charges (see BEMSTAT)
%    inout      :  fields inside (inout = 1, default) or
%                        outside (inout = 2) of particle surface
%  Output
%    field      :  compstruct object with electric field

if ~exist( 'inout', 'var' ),  inout = 1;  end

%  derivative of Green function
if inout == 1
  Hp = eval( obj.g, 'H1p' );
else
  Hp = eval( obj.g, 'H2p' );
end
%  electric field
e = - matmul( Hp, sig.sig );

%  set output
field = compstruct( obj.p1, sig.enei, 'e', e );
