function field = field( obj, sig, inout )
%  Electric field inside/outside of particle surface.
%    Computed from solutions of Maxwell equations within the
%    quasistatic approximation.
%
%  Usage for obj = compgreenstatmirror :
%    field = field( obj, sig, inout )
%  Input
%    sig        :  compstructmirror object(s) with surface charges 
%    inout      :  electric field inside (inout = 1, default) or
%                                outside (inout = 2) of particle
%  Output
%    field      :  compstructmirror object with electric field

%  cannot compute fields from just normal surface derivative
assert( strcmp( obj.g.deriv, 'cart' ) );

%  default value for inout
if ~exist( 'inout', 'var' ),  inout = 1;  end
%  allocate output array
field = compstructmirror( sig.p, sig.enei, sig.fun );

%  get distance and derivative of Green function
Gp = subsref( obj, substruct( '.', 'Gp' ) );
%  divergent part for diagonal Green function elements
div = subsref( [ 1, -1 ], substruct( '()', { inout } ) ) *  ...
                             2 * pi * outer( obj.p.nvec, eye( obj.p.n ) );
%  add divergent part to Green function
H = cellfun( @( Gp ) Gp + div, Gp, 'UniformOutput', false );

%  loop over input variables
for i = 1 : length( sig.val )  
  %  surface charge
  isig = sig.val{ i };
  %  index of symmetry values within symmetry table
  ind = obj.p.symindex( isig.symval( end, : ) );
  %  electric field
  e = - matmul( H{ ind }, isig.sig );
  %  set output
  field.val{ i } = compstruct( isig.p, isig.enei, 'e', e );
  %  set symmetry value
  field.val{ i }.symval = isig.symval;
end
