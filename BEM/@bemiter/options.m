function op = options( varargin )
%  OPTIONS - Set options for iterative BEM solver.
%
%  Usage :
%    op = bemiter.options( PropertyPairs )
%  PropertyName
%    'solver'   :  'gmres', 'cgs', or 'bicgstab'
%    'tol'      :  tolerance for iterative solver
%    'maxit'    :  maximum number of iterations
%    'restart'  :  restart for GMRES solver
%    'precond'  :  [] or 'hmat'
%    'output'   :  intermediate output for iterative solver
%    'cleaf'    :  threshold parameter for bisection
%    'fadmiss'  :  function for admissibility
%    'htol'     :  tolerance for termination of aca loop
%    'kmax'     :  maximum rank for low-rank matrices

%  set default values
op = struct(  ...
  'solver',  'gmres',       ...      
  'tol',     1e-6,          ...
  'maxit',   100,           ...
  'restart', [],            ...
  'precond', 'hmat',        ...
  'output',  0,             ...
  'cleaf',   200,           ...
  'htol',    1e-6,          ...
  'kmax',  [ 4, 100 ],      ...
  'fadmiss', @( rad1, rad2, dist ) 2.5 * min( rad1, rad2 ) < dist );

%  extract input
in = getbemoptions( varargin{ : } );
%  options for iterative solver
if isfield( in, 'solver'  ),  op.solver  = in.solver;   end
if isfield( in, 'tol'     ),  op.tol     = in.tol;      end
if isfield( in, 'maxit'   ),  op.maxit   = in.maxit;    end
if isfield( in, 'restart' ),  op.restart = in.restart;  end
if isfield( in, 'precond' ),  op.precond = in.precond;  end
if isfield( in, 'output'  ),  op.output  = in.output;   end
%  options for H-matrices and aca
if isfield( in, 'cleaf'   ),  op.cleaf   = in.cleaf;    end
if isfield( in, 'fadmiss' ),  op.fadmiss = in.fadmiss;  end
if isfield( in, 'htol'    ),  op.htol    = in.htol;     end
if isfield( in, 'kmax'    ),  op.kmax    = in.kmax;     end
