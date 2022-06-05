function obj = setiter( obj, flag, relres, iter )
%  SETITER - Set statistics for iterative solver.
%
%  Usage for obj = bemiter :
%    obj = setiter( obj, flag, relres, iter )
%  Input
%    flag       :  convergence flag
%    relres     :  relative residual norm
%    iter       :  outer and inner iteration numbers

if ~( issorted( [ obj.eneisav; obj.enei ] ) ||  ...
      issorted( flipud( [ obj.eneisav; obj.enei ] ) ) )
  %  reset statistics
  [ obj.flag, obj.relres, obj.iter, obj.eneisav ] = deal( [] );
end

%  make ITER 2d
if numel( iter ) == 1,  iter( 2 ) = 0;  end
%  save statistics
obj.flag    = [ obj.flag;    flag     ];
obj.relres  = [ obj.relres;  relres   ];
obj.iter    = [ obj.iter;    iter     ];
obj.eneisav = [ obj.eneisav; obj.enei ];
