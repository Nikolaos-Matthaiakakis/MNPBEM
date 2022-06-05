function obj = initmat( obj, enei )
%  Initialize Green functions and preconditioner for iterative BEM solver.
%    see Waxenegger et al., Comp. Phys. Commun. 193, 128 (2015).
    
%  use previously computed matrices ?
if isempty( obj.enei ) || obj.enei ~= enei
  
  obj.enei = enei;
  %  wavenumber
  obj.k = 2 * pi / enei;
  %  dielectric function
  obj.eps1 = obj.p.eps1( enei );
  obj.eps2 = obj.p.eps2( enei );  
 
  %  initialize timer
  obj = tocout( obj, 'init', { 'G1', 'H1', 'G2', 'H2', 'G1i', 'G2pi',  ...
                               'Sigma1', 'Sigma2p', 'Gamma', 'm', 'im' } );  
  
  %  Green functions for inner surfaces
  G1 = obj.g{ 1, 1 }.G(  enei ) - obj.g{ 2, 1 }.G(  enei );  obj = tocout( obj, 'G1' );
  H1 = obj.g{ 1, 1 }.H1( enei ) - obj.g{ 2, 1 }.H1( enei );  obj = tocout( obj, 'H1' );
  %  Green functions for outer surfaces
  G2 = obj.g{ 2, 2 }.G(  enei );  g2 = obj.g{ 1, 2 }.G(  enei );  obj = tocout( obj, 'G2' );
  H2 = obj.g{ 2, 2 }.H2( enei );  h2 = obj.g{ 1, 2 }.H2( enei );  obj = tocout( obj, 'H2' );
  %  add mixed contributions
  G2.ss = G2.ss - g2;  G2.hh = G2.hh - g2;  G2.p = G2.p - g2;
  H2.ss = H2.ss - h2;  H2.hh = H2.hh - h2;  H2.p = H2.p - h2;
  
  %  save Green functions
  [ obj.G1, obj.H1, obj.G2, obj.H2 ] = deal( G1, H1, G2, H2 );
  %  initialize preconditioner
  if ~isempty( obj.precond ),  obj = initprecond( obj, enei );  end
  obj = tocout( obj, 'close' );
  
  %  save statistics
  obj = setstat( obj, 'G1', obj.G1 );  obj = setstat( obj, 'H1', obj.H1 );
  % loop over names 
  for name = fieldnames( G2 ) .'
    obj = setstat( obj, 'G2', obj.G2.( name{ 1 } ) );
    obj = setstat( obj, 'H2', obj.H2.( name{ 1 } ) );
  end
end
