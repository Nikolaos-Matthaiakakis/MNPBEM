function [ x, obj ] = solve( obj, x0, b, afun, mfun )
%  SOLVE - Iterative solution of BEM equations.
%
%  Usage for obj = bemiter :
%    x = solve( obj, x0, b, afun, mfun )
%  Input
%    x0     :  initial guess for solution vector
%    b      :  inhomogeneity, A * x = b
%    afun   :  evaluate A * x
%    mfun   :  preconditioner, evaluate M * x
%  Output
%    x      :  solution vector

%  use only preconditioner ?
if obj.maxit == 0 || isempty( obj.solver )
  %  make sure that preconditioner is set
  assert( strcmp( obj.precond, 'hmat' ) );
  %  compute solution vector
  x = mfun( b );

%  iterative solution  
else
  %  iterative solution through builtin Matlab functions
  switch obj.solver
    case 'cgs'
      %  conjugate gradient solver
      [ x, flag, relres, iter ] =  ...
            cgs( afun, b,              obj.tol, obj.maxit, mfun, [], x0 );
    case 'bicgstab'
      %  biconjugate gradients stabilized method
      [ x, flag, relres, iter ] =  ...
        bicgstab( afun, b,             obj.tol, obj.maxit, mfun, [], x0 );
    case 'gmres'
      %  generalized minimum residual method (with restarts)
      [ x, flag, relres, iter ] =  ...
          gmres( afun, b, obj.restart, obj.tol, obj.maxit, mfun, [], x0 );    
    otherwise
      error( 'iterative solver not known' );
  end

  %  save statistics
  obj = setiter( obj, flag, relres, iter );
  %  print statistics
  if obj.output,  printstat( obj, flag, relres, iter );  end
end
