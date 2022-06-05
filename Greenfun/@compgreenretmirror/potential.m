function pot = potential( obj, sig, inout )
%  Determine potentials and surface derivatives inside/outside of particle.
%    Computed from solutions of full Maxwell equations.
%
%  Usage for obj = compgreenretmirror :
%    pot = potentialret( obj, sig, inout )
%  Input
%    sig        :  surface charges
%    inout      :  potentials inside (inout = 1, default) or
%                            outside (inout = 2) of particle
%  Output
%    pot        :  potentials and  surface derivatives

if ~exist( 'inout', 'var' ), inout = 1;  end
%  wavelength of light in vacuum
enei = sig.enei;
%  allocate output
pot = compstructmirror( sig.p, sig.enei, sig.fun );

%  inside or outside surface derivative
H = subsref( { 'H1', 'H2' }, substruct( '{}', { inout } ) );

%  Green function and E = i k A
G1 = subsref( obj, substruct( '{}', { inout, 1 }, '.', 'G', '()', { enei } ) );
G2 = subsref( obj, substruct( '{}', { inout, 2 }, '.', 'G', '()', { enei } ) );
%  surface derivatives of Green function
H1 = subsref( obj, substruct( '{}', { inout, 1 }, '.', H, '()', { enei } ) );
H2 = subsref( obj, substruct( '{}', { inout, 2 }, '.', H, '()', { enei } ) );

%  loop over symmetry values
for i = 1 : length( sig.val );
  
  %  surface charge
  isig = sig.val{ i };
  %  index of symmetry values within symmetry table
  x = obj.p.symindex( isig.symval( 1, : ) );
  y = obj.p.symindex( isig.symval( 2, : ) );
  z = obj.p.symindex( isig.symval( 3, : ) );
  %  index array
  ind = [ x, y, z ];

  %  scalar potential
  phi  = matmul( G1{ z }, isig.sig1 ) + matmul( G2{ z }, isig.sig2 );
  phip = matmul( H1{ z }, isig.sig1 ) + matmul( H2{ z }, isig.sig2 );
  %  vector potential
  a  = indmul( G1, isig.h1, ind ) + indmul( G2, isig.h2, ind );
  ap = indmul( H1, isig.h1, ind ) + indmul( H2, isig.h2, ind );
   
  if inout == 1
    pot.val{ i } = compstruct( sig.p, enei,  ...
                         'phi1', phi, 'phi1p', phip, 'a1', a, 'a1p', ap );  
  else
    pot.val{ i } = compstruct( sig.p, enei,  ...
                         'phi2', phi, 'phi2p', phip, 'a2', a, 'a2p', ap );      
  end
  %  set symmmetry value
  pot.val{ i }.symval = sig.val{ i }.symval;  
end
end


function  u = indmul( mat, v, ind )
%  INDMUL - Matrix multiplication for given index

if length( mat{ 1 } ) == 1 && mat{ 1 } == 0
  u = 0;
else
  siz = size( v );  siz( 2 ) = 1;  
  u = cat( 2, matmul( mat{ ind( 1 ) }, reshape( v( :, 1, : ), siz ) ),  ...
              matmul( mat{ ind( 2 ) }, reshape( v( :, 2, : ), siz ) ),  ...
              matmul( mat{ ind( 3 ) }, reshape( v( :, 3, : ), siz ) ) );
end
end
