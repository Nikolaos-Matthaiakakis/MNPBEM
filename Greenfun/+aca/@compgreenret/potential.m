function pot = potential( g, sig, inout, varargin )
%  Potentials and surface derivatives inside/outside of particle.
%    Computed from solutions of full Maxwell equations.
%
%  Usage for obj = compgreenret :
%    field = potential( obj, sig, inout )
%    field = potential( obj, sig, inout, varargin )
%  Input
%    sig        :  compstruct with surface charges (see bemstat)
%    inout      :  potentials inside (inout = 1, default) or
%                            outside (inout = 2) of particle
%    varargin   :  pass additional arguments to Green function
%  Output
%    pot        :  compstruct object with potentials & surface derivatives

enei = sig.enei;

%%  potential inside of particle on default
if ~exist( 'inout', 'var' )
  inout = 1;
end
var = { enei, varargin{ : } };
%  set parameters that depend on inside/outside
H = subsref( { 'H1', 'H2' }, substruct( '{}', { inout } ) );

%%  Green functions
G1 = subsref( g, substruct( '{}', { inout, 1 }, '.', 'G', '()', var ) );
G2 = subsref( g, substruct( '{}', { inout, 2 }, '.', 'G', '()', var ) );
%  surface derivatives of Green functions
H1 = subsref( g, substruct( '{}', { inout, 1 }, '.', H, '()', var ) );
H2 = subsref( g, substruct( '{}', { inout, 2 }, '.', H, '()', var ) );

%%  potential and surface derivative
matmul = @( x, y ) reshape( x * reshape( y, size( y, 1 ), [] ), size( y ) );
%  scalar potential
phi  = matmul( G1, sig.sig1 ) + matmul( G2, sig.sig2 );
phip = matmul( H1, sig.sig1 ) + matmul( H2, sig.sig2 );
%  vector potential
a  = matmul( G1, sig.h1 ) + matmul( G2, sig.h2 );
ap = matmul( H1, sig.h1 ) + matmul( H2, sig.h2 );

%%  set output
if inout == 1
  pot = compstruct( g.p, enei,  ...
                  'phi1', phi, 'phi1p', phip, 'a1', a, 'a1p', ap );
else
  pot = compstruct( g.p, enei,  ...
                  'phi2', phi, 'phi2p', phip, 'a2', a, 'a2p', ap );  
end
