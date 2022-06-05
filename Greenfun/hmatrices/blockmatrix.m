classdef blockmatrix
  %  Base class for block matrix.
  %    Given a block matrix with submatrices of size SIZ1 x SIZ2, this
  %    class provides a conversion of indices from total to submatrices
  %    and vice versa.
  
  %%  Properties   
  properties
    siz1      %  row sizes of submatrices
    siz2      %  column sizes of submatrices
  end
  
  properties (Access = private)
    n1, n2    %  total matrix size
    row       %  cell matrix with initial rows of submatrices
    col       %  cell matrix with initial columns of submatrices
    siz       %  size of submatrices
  end
    
  %%  Methods
  methods
    function obj = blockmatrix( varargin )
      %  Initialize block matrix.
      %
      %  Usage :
      %    obj = blockmatrix( siz1, siz2 )
      %  Input
      %    siz1   :  row sizes of submatrices
      %    siz2   :  column sizes of submatrices
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'blockmatrix : ' );
      disp( struct( 'siz1', obj.siz1, 'siz2', obj.siz2 ) );
    end
    
    function [ sub, ind ] = ind2sub( obj, ind )
      %  IND2SUB - Convert total index to cell array of subindices.
      %
      %  Usage for obj = blockmatrix :
      %    [ sub, ind ] = ind2sub( obj, ind )
      %  Input
      %    ind    :  total index
      %  Output
      %    sub    :  cell array of subindices
      %    ind    :  index array to be used in ACCUMARRAY
      
      %  convert to row and column indices
      [ r, c ] = ind2sub( [ obj.n1, obj.n2 ], ind );
      %  find sub-matrices for columns and rows
      [ ~, indr ] = histc( r, [ 0, cumsum( obj.siz1 ) ] + 1 );
      [ ~, indc ] = histc( c, [ 0, cumsum( obj.siz2 ) ] + 1 );
      
      %  accumulate function
      fun = @( ind, val )  ...
        builtin( 'accumarray', ind, val, size( obj.siz ), @( x ) { x } );
      %  group elements to cell arrays
      r   = fun( { indr, indc }, r );
      c   = fun( { indr, indc }, c );
      ind = fun( { indr, indc }, 1 : numel( ind ) );
      %  convert to subindices
      sub = cellfun( @( r, c, r0, c0, siz ) sub2ind( siz, r - r0, c - c0 ),  ...
                                r, c, obj.row, obj.col, obj.siz, 'uniform', 0 );
    end
    
    function val = accumarray( ~, ind, val )
      %  ACCUMARRAY - Assembly together array.
      %
      %  Usage for obj = accumarray :
      %    val = accumarray( obj, ind, val )
      %  Input
      %    ind    :  index array from previous call to IND2SUB
      %    val    :  cell array with values
      %  Output
      %    val    :  total value array
      val = accumarray( vertcat( ind{ : } ), vertcat( val{ : } ) ); 
    end
           
  end  
  
  methods (Access = private)
    function obj = init( obj, siz1, siz2 )
      %  INIT - Initialize block matrix.
      [ obj.siz1, obj.siz2 ] = deal( siz1, siz2 );
      %  total size of block matrix
      [ obj.n1, obj.n2 ] = deal( sum( siz1 ), sum( siz2 ) );
      
      %  initial rows and columns of submatrices
      r = [ 0, cumsum( siz1( 1 : end - 1 ) ) ];
      c = [ 0, cumsum( siz2( 1 : end - 1 ) ) ];
      %  convert to cell matrix
      obj.row = num2cell( repmat( r .', 1, numel( c ) ) );
      obj.col = num2cell( repmat( c   , numel( r ), 1 ) );
      %  size of submatrices
      obj.siz = arrayfun( @( siz1, siz2 ) [ siz1, siz2 ],    ...
                  repmat( siz1( : )   , 1, numel( siz2 ) ),  ...
                  repmat( siz2( : ) .', numel( siz1 ), 1 ), 'uniform', 0 );
    end    
  end
  
end