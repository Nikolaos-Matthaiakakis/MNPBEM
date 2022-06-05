function pot = potential( obj, sig, inout )
%  Determine potentials and surface derivatives inside/outside of particle.
%
%  Usage for obj = aca.compgreenstat :
%    pot = potential( obj, sig, inout )
%  Input
%    sig        :  compstruct with surface charges (see BEMSTAT)
%    inout      :  potentials inside (inout = 1, default) or
%                            outside (inout = 2) of particle surface
%  Output
%    pot        :  compstruct object with potentials & surface derivatives

%  potential inside of particle on default
if ~exist( 'inout', 'var' ),  inout = 1;  end
%  set parameters that depend on inside/outside
H = subsref( { 'H1', 'H2' }, substruct( '{}', { inout } ) );
%  get Green function and surface derivative
[ G, H ] = eval( obj, 'G', H );

matmul = @( x, y ) reshape( x * reshape( y, size( y, 1 ), [] ), size( y ) );
%  potential and surface derivative
phi  = matmul( G, sig.sig );
phip = matmul( H, sig.sig );

%  set output
if inout == 1
  pot = compstruct( obj.p, sig.enei, 'phi1', phi, 'phi1p', phip );
else
  pot = compstruct( obj.p, sig.enei, 'phi2', phi, 'phi2p', phip );  
end
