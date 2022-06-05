function field = field( obj, sig, inout )
%  Electric and magnetic fields inside/outside of particle surface.
%
%  Usage for obj = compgreenretlayer :
%    field = field( obj, sig, enei, inout, varargin )
%  Input
%    sig        :  compstruct with surface charges and currents
%    inout      :  fields inside (inout = 1, default) or
%                        outside (inout = 2) of particle surface
%  Output
%    field      :  compstruct object with electric and magnetic fields

%  wavelength and wavenumber of of light in vacuum
[ enei, k ] = deal( sig.enei, 2 * pi / sig.enei );

%  field inside of particle on default
if ~exist( 'inout', 'var' ),  inout = 1;  end
%  initialize reflected Green functions
obj = initrefl( obj, enei );

%  Green function and E = i k A
e = 1i * k * ( matmul2( eval( obj, inout, 1, 'G', enei ), sig, 'h1' ) +  ...
               matmul2( eval( obj, inout, 2, 'G', enei ), sig, 'h2' ) );

%  derivative of Green function
if inout == 1
  H1p = eval( obj, inout, 1, 'H1p', enei );
  H2p = eval( obj, inout, 2, 'H1p', enei );  
else
  H1p = eval( obj, inout, 1, 'H2p', enei );
  H2p = eval( obj, inout, 2, 'H2p', enei );  
end             
%  add derivative of scalar potential to electric field
e = e - matmul2( H1p, sig, 'sig1' ) - matmul2( H2p, sig, 'sig2' );
%  magnetic field
h = cross( H1p, sig, 'h1' ) + cross( H2p, sig, 'h2' );
           
%  set output
field = compstruct( obj.p1, enei, 'e', e, 'h', h );


function cross = cross( G, sig, name )
%  CROSS - Multidimensional cross product.

if numel( G ) == 1 && ~isstruct( G ),  cross = 0; return;  end

%  cross product
cross = cat( 2,  ...
  matmul3( G, sig, name, 2, 3 ) - matmul3( G, sig, name, 3, 2 ),  ...
  matmul3( G, sig, name, 3, 1 ) - matmul3( G, sig, name, 1, 3 ),  ...
  matmul3( G, sig, name, 1, 2 ) - matmul3( G, sig, name, 2, 1 ) );
