function varargout = info( obj )
%  INFO - Get information for iterative solver.
%
%  Usage for obj = bemiter :
%    info( obj )                            -  print statistics
%    [ flag, relres, iter ] = info( obj )   -  get   statistics
%  Input
%    flag       :  convergence flag
%    relres     :  relative residual norm
%    iter       :  outer and inner iteration numbers

%  get statistics information
[ flag, relres, iter ] = deal( obj.flag, obj.relres, obj.iter );

if nargout == 0
  for i = 1 : numel( flag )
    printstat( obj, flag( i ), relres( i ), iter( i, : ) );
  end
else
  [ varargout{ 1 : 3 } ] = deal( flag, relres, iter );
end
