function field = field( obj, sig, inout )
%  Electric and magnetic field inside/outside of particle surface.
%    Computed from solutions of full Maxwell equations.
%
%  Usage for obj = compgreenret :
%    field = field( obj, sig, enei, inout, varargin )
%  Input
%    sig        :  COMPSTRUCT with surface charges & currents (see bemret)
%    inout      :  fields inside (inout = 1, default) or
%                        outside (inout = 2) of particle surface
%  Output
%    field      :  COMPSTRUCT object with electric and magnetic fields

%  field inside of particle on default
if ~exist( 'inout', 'var' ),  inout = 1;  end
%  wavelength and wavenumber of of light in vacuum
[ enei, k ] = deal( sig.enei, 2 * pi / sig.enei );

%  Green function and E = i k A
e = 1i * k * ( matmul( eval( obj, inout, 1, 'G', enei ), sig.h1 ) +  ...
               matmul( eval( obj, inout, 2, 'G', enei ), sig.h2 ) );

%  derivative of Green function
if inout == 1
  H1p = eval( obj, inout, 1, 'H1p', enei );
  H2p = eval( obj, inout, 2, 'H1p', enei );  
else
  H1p = eval( obj, inout, 1, 'H2p', enei );
  H2p = eval( obj, inout, 2, 'H2p', enei );  
end
%  add derivative of scalar potential to electric field
e = e - matmul( H1p, sig.sig1 ) - matmul( H2p, sig.sig2 );
%  magnetic field
h = cross( H1p, sig.h1 ) + cross( H2p, sig.h2 );
           
%  set output
field = compstruct( obj.p1, enei, 'e', e, 'h', h );


function cross = cross( G, h )
%  CROSS - Multidimensional cross product.

if numel( G ) == 1,  cross = 0; return;  end

%  size of vector field
siz = size( h ); 
siz = siz( [ 1, 3 : end ] );
if numel( siz ) == 1,  siz = [ siz, 1 ];  end
%  get component
at = @( h, i ) reshape( h( :, i, : ), siz );
%  cross product
cross = cat( 2,  ...
  matmul( G( :, 2, : ), at( h, 3 ) ) - matmul( G( :, 3, : ), at( h, 2 ) ),  ...
  matmul( G( :, 3, : ), at( h, 1 ) ) - matmul( G( :, 1, : ), at( h, 3 ) ),  ...
  matmul( G( :, 1, : ), at( h, 2 ) ) - matmul( G( :, 2, : ), at( h, 1 ) ) );
