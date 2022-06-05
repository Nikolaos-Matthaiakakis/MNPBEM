function obj = init( obj, varargin )
%  INIT - Initialize iterative BEM solver.

%  remove ENEI entry ?
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  varargin = varargin( 2 : end );
end

%  extract input
op = getbemoptions( { 'iter', 'bemiter' }, varargin{ : } );
%  options for iterative solver
if isfield( op, 'solver'  ),  obj.solver  = op.solver;   end
if isfield( op, 'tol'     ),  obj.tol     = op.tol;      end
if isfield( op, 'maxit'   ),  obj.maxit   = op.maxit;    end
if isfield( op, 'restart' ),  obj.restart = op.restart;  end
if isfield( op, 'precond' ),  obj.precond = op.precond;  end
if isfield( op, 'output'  ),  obj.output  = op.output;   end
if isfield( op, 'hmode'   ),  obj.hmode   = op.hmode;    end
