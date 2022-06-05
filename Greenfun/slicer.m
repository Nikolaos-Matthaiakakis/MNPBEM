classdef slicer
  %  Successively work through large matrices.
  %    Given the size and indices for a possibly large matrix, this class
  %    provides the functions to successively work through the 'slices' of
  %    the matrix.
  %
  %    %  set up slicer
  %    s = slicer( siz );
  %    %  work through slices
  %    for i = 1 : s.n
  %      %  indices, rows, and columns of slice
  %      [ ind, row, col ] = s( i );
  %   end
  
  %%  Properties   
  properties
    siz     %  size of matrix
    ind1    %  indices for rows of matrix
    ind2    %  indices for columns of matrix
  end
  
  properties 
    n       %  number of slices
    sind2   %  table of slice indices
  end
    
  %%  Methods
  methods
    function obj = slicer( varargin )
      %  Initialize slicer object.
      %
      %  Usage :
      %    obj = slicer( siz,             PropertyPair )
      %    obj = slicer( siz, ind1, ind2, PropertyPair )
      %  Input
      %    siz      :  size of matrix
      %    ind1     :  row indices
      %    ind2     :  column indices
      %  PropertyName
      %    'memsize'    :  maximum memory size 
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'slicer : ' );
      disp( struct( 'siz', obj.siz, 'ind1', obj.ind1, 'ind2', obj.ind2 ) );
    end    
    
    function varargout = subsref( obj, s )
      %  SUBSREF - Derived properties for slicer class.
      switch s( 1 ).type
        case '.'    
          [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
        case '()'
          [ varargout{ 1 : nargout } ] = eval( obj, s.subs{ : } );
      end
    end
    
    function [ ind, row, col ] = eval( obj, i )
      %  EVAL - Compute indices for slice.
      %
      %  Usage for obj = slicer :
      %    [ ind, row, col ] = eval( obj, i )
      %  Input
      %    i        :  slice index
      %  Output
      %    ind      :  matrix indices for slice
      %    row      :  row indices for slice
      %    col      :  column indices for slice
      
      assert( i <= obj.n );
      %  row and column indices
      row = obj.ind1;
      col = obj.ind2( obj.sind2( i ) + 1 : obj.sind2( i + 1 ) );
      %  linear indices
      [ r, c ] = ndgrid( row( : ), col( : ) );
      ind = sub2ind( obj.siz, r( : ), c( : ) );
    end
  end
  
  methods (Access = private)
    function obj = init( obj, siz, varargin )
      %  INIT - Initialize slicer object.
      
      obj.siz = siz;
      %  deal with different calling sequences
      if ~isempty( varargin ) && ~ischar( varargin{ 1 } )
        [ obj.ind1, obj.ind2, varargin ] =  ...
          deal( varargin{ 1 }, varargin{ 2 }, varargin( 3 : end ) );
      else
        [ obj.ind1, obj.ind2 ] = deal( 1 : siz( 1 ), 1 : siz( 2 ) );
      end
      %  use default value for memory size
      op = getbemoptions( varargin{ : } );
      if ~isfield( op, 'memsize' ),  op.memsize = misc.memsize;  end
      %  make sure that MEMSIZE is large enough
      assert( op.memsize > siz( 1 ) );
      
      %  table of slice indices
      k = 0 : fix( op.memsize / numel( obj.ind1 ) ) : numel( obj.ind2 );
      if k( end ) ~= numel( obj.ind2 ),  k = [ k, numel( obj.ind2 ) ];  end
      %  save slice indices and number of slices
      [ obj.sind2, obj.n ] = deal( k, numel( k ) - 1 );
    end
    
  end
end