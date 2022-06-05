classdef hmatrix
  %  Hierarchical matrix.
  %    Using a cluster tree and an admissibility matrix for the application
  %    of low-rank approximations, this class stores and manipulates
  %    low-rank hierarchical matrices.
  %
  %  See S. Boerm et al., Eng. Analysis with Bound. Elem. 27, 405 (2003).
  
  %%  Properties   
  properties
    tree            %  cluster tree
    htol = 1e-6     %  tolerance for low-rank approximation
    kmax = 100      %  maximum rank for low-rank matrix
  end
  
  properties
    row1, col1      %  rows and columns for full-rank matrices
    row2, col2      %  rows and columns for  low-rank matrices
    val             %  full matrix
    lhs,  rhs       %  low-rank matrix lhs * transp( rhs )
    
    op              %  option structure
    stat            %  statistics returned from MEX functions for
                    %    H-matrix multiplication and inversion
  end

  %%  Methods
  methods
    function obj = hmatrix( varargin )
      %  Initialize hierarchical matrix.
      %
      %  Usage :
      %    obj = hmatrix( tree, op, PropertyPairs )
      %  Input
      %    tree     :  cluster tree
      %  PropertyName
      %    fadmiss  :  function for admissibility, e.g.
      %                  @( rad1, rad2, dist ) 2 * min( rad1, rad2 ) < dist
      %    htol     :  tolerance for low-rank approximation
      if ~isempty( varargin ),  obj = init( obj, varargin{ : } );  end
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'hmatrix : ' );
      disp( struct( 'tree', obj.tree, 'htol', obj.htol, 'kmax', obj.kmax,  ...
                   'val', { obj.val }, 'lhs', { obj.lhs }, 'rhs', { obj.rhs } ) );
    end
  end
  
  methods (Access = private)
    obj = init( obj, varargin );
  end
  
end
