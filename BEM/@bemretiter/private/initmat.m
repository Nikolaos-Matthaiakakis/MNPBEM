function obj = initmat( obj, enei )
%  Initialize Green functions and preconditioner for iterative BEM solver.
    
%  use previously computed matrices ?
if isempty( obj.enei ) || obj.enei ~= enei
  
  obj.enei = enei;
  %  wavenumber
  obj.k = 2 * pi / enei;
  %  dielectric function
  obj.eps1 = obj.p.eps1( enei );
  obj.eps2 = obj.p.eps2( enei );
  
  obj = tocout( obj, 'init', { 'G1', 'G2', 'H1', 'H2', 'G1i', 'G2i',  ...
                               'Sigma1', 'Sigma2', 'Deltai', 'Sigmai' } );
  
  %  Green functions and surface derivatives
  obj.G1 = obj.g{ 1, 1 }.G( enei ) - obj.g{ 2, 1 }.G( enei );  obj = tocout( obj, 'G1' );
  obj.G2 = obj.g{ 2, 2 }.G( enei ) - obj.g{ 1, 2 }.G( enei );  obj = tocout( obj, 'G2' );
     
  obj.H1 = obj.g{ 1, 1 }.H1( enei ) - obj.g{ 2, 1 }.H1( enei );  obj = tocout( obj, 'H1' );
  obj.H2 = obj.g{ 2, 2 }.H2( enei ) - obj.g{ 1, 2 }.H2( enei );  obj = tocout( obj, 'H2' );
  
  %  initialize preconditioner
  if ~isempty( obj.precond ),  obj = initprecond( obj, enei );  end
  obj = tocout( obj, 'close' );
  
  %  save statistics
  obj = setstat( obj, 'G1', obj.G1 );  obj = setstat( obj, 'H1', obj.H1 );
  obj = setstat( obj, 'G2', obj.G2 );  obj = setstat( obj, 'H2', obj.H2 );
end


