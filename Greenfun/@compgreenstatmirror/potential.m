function pot = potential( obj, sig, inout )
%  Determine potentials and surface derivatives inside/outside of particle.
%
%  Usage for obj = compgreenstatmirror :
%    pot = potential( obj, sig, inout )
%  Input
%    sig        :  surface charges
%    inout      :  potentials inside (inout = 1, default) or
%                            outside (inout = 2) of particle
%  Output
%    pot        :  COMPSTRUCTMIRROR object with potentials and
%                                               surface derivatives

%  potential inside of particle on default
if ~exist( 'inout', 'var' ),  inout = 1;  end
%  allocate output array
pot = compstructmirror( sig.p, sig.enei, sig.fun );

%  set parameters that depend on inside/outside
H = subsref( { 'H1', 'H2' }, substruct( '{}', { inout } ) );

%  Green function and surface derivative
G = subsref( obj, substruct( '.', 'G' ) );
H = subsref( obj, substruct( '.',  H  ) );

%  compute potential and surface derivative
for i = 1 : length( sig.val )
  %  surface charge
  isig = sig.val{ i };
  %  get symmetry value
  ind = obj.p.symindex( isig.symval( end, : ) );
  %  potential and surface derivative
  phi  = matmul( G{ ind }, isig.sig );
  phip = matmul( H{ ind }, isig.sig );

  if inout == 1
    pot.val{ i } = compstruct( sig.p, sig.enei, 'phi1', phi, 'phi1p', phip );
  else
    pot.val{ i } = compstruct( sig.p, sig.enei, 'phi2', phi, 'phi2p', phip );  
  end
  %  set symmetry value
  pot.val{ i }.symval = isig.symval;
end
