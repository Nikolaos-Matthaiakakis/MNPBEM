classdef bemiter
  %  Base class for iterative BEM solvers.
  
  %%  Properties 
  properties
    solver  = 'gmres'   %  iterative solver, 'cgs', ' bicgstab', or 'gmres'
    tol     = 1e-4      %  tolerance
    maxit   = 200       %  maximum number of iterations
    restart = []        %  restart for GMRES solver
    precond = 'hmat'    %  preconditioner for iterative solver
    output  = 0         %  intermediate output for iterative solver
  end
  
  properties (Access = protected)
    flag      %  flag from iterative Matlab routine
    relres    %  relative residual error
    iter      %  number of iterations
    eneisav   %  previously computed wavelengths
    stat      %  statistics for H-matrices
    timer     %  timer statistics
  end  
    
  %%  Methods
  methods
    function obj = bemiter( varargin )
      %  Initialize BEM solver.
      %
      %  Usage :
      %    obj = bemiter( op, PropertyName, PropertyValue, ... )
      %  PropertyName
      %    'solver'     :  'cgs', ' bicgstab', or 'gmres'
      %    'tol'        :  tolerance for iterative solver
      %    'maxit'      :  maximum number of iterations
      %    'restart'    :  restart for GMRES solver
      %    'precond'    :  [] or 'hmat'
      %    'output'     :  intermediate output for iterative solver
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'bemiter : ' );
      disp( struct( 'solver',  obj.solver,  'tol',     obj.tol,      ...
                    'maxit',   obj.maxit,   'restart', obj.restart,  ...
                    'precond', obj.precond, 'output',  obj.output ) );
    end
  end
  
  methods (Static)
    op = options( varargin );
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
    printstat(  obj, varargin );
  end
    
end
