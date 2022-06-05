function pot = potential( obj, sig, inout )
%  Potentials and surface derivatives inside/outside of particle.
%
%  Usage for obj = compgreenretlayer :
%    field = potential( obj, sig, inout )
%  Input
%    sig        :  compstruct with surface charges (see bemstat)
%    inout      :  potentials inside (inout = 1, default) or
%                            outside (inout = 2) of particle
%  Output
%    pot        :  compstruct object with potentials and surface derivatives

enei = sig.enei;

%  potential inside of particle on default
if ~exist( 'inout', 'var' ),  inout = 1;  end
%  initialize reflected Green functions
obj = initrefl( obj, enei );
%  set parameters that depend on inside/outside
H = subsref( { 'H1', 'H2' }, substruct( '{}', { inout } ) );

%  Green functions
G1 = subsref( obj, substruct( '{}', { inout, 1 }, '.', 'G', '()', { enei } ) );
G2 = subsref( obj, substruct( '{}', { inout, 2 }, '.', 'G', '()', { enei } ) );
%  surface derivatives of Green functions
H1 = subsref( obj, substruct( '{}', { inout, 1 }, '.', H, '()', { enei } ) );
H2 = subsref( obj, substruct( '{}', { inout, 2 }, '.', H, '()', { enei } ) );

%  potential and surface derivative
%  scalar potential
phi  = matmul2( G1, sig, 'sig1' ) + matmul2( G2, sig, 'sig2' );
phip = matmul2( H1, sig, 'sig1' ) + matmul2( H2, sig, 'sig2' );
%  vector potential
a  = matmul2( G1, sig, 'h1' ) + matmul2( G2, sig, 'h2' );
ap = matmul2( H1, sig, 'h1' ) + matmul2( H2, sig, 'h2' );

%  set output
if inout == 1
  pot = compstruct( obj.p1, enei,  ...
                  'phi1', phi, 'phi1p', phip, 'a1', a, 'a1p', ap );
else
  pot = compstruct( obj.p1, enei,  ...
                  'phi2', phi, 'phi2p', phip, 'a2', a, 'a2p', ap );  
end
