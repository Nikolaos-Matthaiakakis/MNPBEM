function printstat( obj, flag, relres, iter )
%  PRINTSTAT - Print statistics for iterative solver.

switch obj.solver
  case 'cgs'
    %  conjugate gradient solver
    fprintf( 1, 'cgs(%i), it=%3i, res=%10.4g, flag=%i\n',  ...
      obj.maxit, iter( 1 ), relres, flag );
  case 'bicgstab'
    %  biconjugate gradients stabilized method
    fprintf( 1, 'bicgstab(%i), it=%5.1f, res=%10.4g, flag=%i\n',  ...
        obj.maxit, iter( 1 ), relres, flag );    
  case 'gmres'
    %  generalized minimum residual method (with restarts)
    fprintf( 1, 'gmres(%i), it=%3i(%i), res=%10.4g, flag=%i\n',  ...
      obj.maxit, iter( 2 ), iter( 1 ), relres, flag );
end
