function field = field( obj, sig, inout )
%  FIELD - Electric and magnetic field inside/outside of particle surface.
%
%  Usage for obj = compgreenretmirror :
%    field = field( obj, sig, inout )
%  Input
%    sig        :  surface charges and currents
%    inout      :  fields inside (inout = 1, default) or
%                        outside (inout = 2) of particle surface
%  Output
%    field      :  COMPSTRUCTMIRROR object with electric and magnetic fields

%  cannot compute fields from just normal surface derivative
assert( strcmp( obj.g.deriv, 'cart' ) );

%  field inside of particle on default
if ~exist( 'inout', 'var' ),  inout = 1;  end
%  wavelength and wavenumber of of light in vacuum
[ enei, k ] = deal( sig.enei, 2 * pi / sig.enei );
%  allocate output
field = compstructmirror( sig.p, sig.enei, sig.fun );

%  Green function
G1 = subsref( obj, substruct( '{}', { inout, 1 }, '.', 'G', '()', { enei } ) );
G2 = subsref( obj, substruct( '{}', { inout, 2 }, '.', 'G', '()', { enei } ) );
%  derivative of Green function
if inout == 1
  H1p = subsref( obj, substruct( '{}', { inout, 1 }, '.', 'H1p', '()', { enei } ) );
  H2p = subsref( obj, substruct( '{}', { inout, 2 }, '.', 'H1p', '()', { enei } ) );
else
  H1p = subsref( obj, substruct( '{}', { inout, 1 }, '.', 'H2p', '()', { enei } ) );
  H2p = subsref( obj, substruct( '{}', { inout, 2 }, '.', 'H2p', '()', { enei } ) );
end

%  loop over symmetry values
for i = 1 : length( sig.val )
  %  surface charge
  isig = sig.val{ i };
  %  index of symmetry values within symmetry table
  x = obj.p.symindex( isig.symval( 1, : ) );
  y = obj.p.symindex( isig.symval( 2, : ) );
  z = obj.p.symindex( isig.symval( 3, : ) );
  %  index array
  ind = [ x, y, z ];
    
  %  electric field  E = i k A - grad V  
  e = 1i * k * indmul( G1, isig.h1, ind ) - matmul( H1p{ z }, isig.sig1 ) +  ...
      1i * k * indmul( G2, isig.h2, ind ) - matmul( H2p{ z }, isig.sig2 );
  %  magnetic field
  h = indcross( H1p, isig.h1, ind ) + indcross( H2p, isig.h2, ind );
  
  %  set output
  field.val{ i } = compstruct( sig.p, sig.enei, 'e', e, 'h', h );
  %  set symmmetry value
  field.val{ i }.symval = sig.val{ i }.symval;  
end
end


function  u = indmul( mat, v, ind )
%  INDMUL - Indexed matrix multiplication.

if length( mat{ 1 } ) == 1 && mat{ 1 } == 0
  u = 0;
else
  siz = size( v );  siz( 2 ) = 1;  
  u = cat( 2, matmul( mat{ ind( 1 ) }, reshape( v( :, 1, : ), siz ) ),  ...
              matmul( mat{ ind( 2 ) }, reshape( v( :, 2, : ), siz ) ),  ...
              matmul( mat{ ind( 3 ) }, reshape( v( :, 3, : ), siz ) ) );
end
end

function  u = indcross( mat, v, ind )
%  INDCROSS - Indexed cross product.

if length( mat{ 1 } ) == 1 && mat{ 1 } == 0
  u = 0;
else
  siz = size( v );  siz( 2 ) = 1;  
  %  matrix and vector function
  imat = @( k, i ) squeeze( mat{ ind( k ) }( :, i, : ) );
  ivec = @( i ) reshape( v( :, i, : ), siz );
  
  u = cat( 2, matmul( imat( 3, 2 ), ivec( 3 ) ) - matmul( imat( 2, 3 ), ivec( 2 ) ),  ...
              matmul( imat( 1, 3 ), ivec( 1 ) ) - matmul( imat( 3, 1 ), ivec( 3 ) ),  ...
              matmul( imat( 2, 1 ), ivec( 2 ) ) - matmul( imat( 1, 2 ), ivec( 1 ) ) );
end
end
