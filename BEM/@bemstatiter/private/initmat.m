function obj = initmat( obj, enei )
%  Initialize Green functions and preconditioner for iterative BEM solver.
    
%  use previously computed matrices ?
if isempty( obj.enei ) || obj.enei ~= enei
        
  obj.enei = enei;
  %  dielectric functions
  eps1 = obj.p.eps1( enei );
  eps2 = obj.p.eps2( enei );
  %  Lambda function [Garcia de Abajo, Eq. (23)]
  obj.lambda = 2 * pi * ( eps1 + eps2 ) ./ ( eps1 - eps2 );
    
  %  initialize preconditioner
  if ~isempty( obj.precond )
    %  surface derivative of Green function 
    F = obj.F;
    lambda = spdiag( obj.lambda );
    %  resolvent matrix
    switch obj.precond
      case 'hmat'
        %    change tolerance and maximale rank        
        [ F.htol, F.kmax ] = deal( max( obj.op.htol ), min( obj.op.kmax ) );
        %  initialize preconditioner
        obj.mat = lu( - lambda - F );
        %  save statistics for H-matrix operation
        obj = setstat( obj, 'mat', obj.mat );
      case 'full'
        %  initialize preconditioner
        obj.mat = inv( - lambda - full( F ) );
      otherwise
        error( 'preconditioner not known' );
    end
  end
end
