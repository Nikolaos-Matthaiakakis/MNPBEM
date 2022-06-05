function ind = inside( obj, varargin )
%  INSIDE - Determine whether coordinates are inside of tabulated range.
%
%  Usage for obj = compgreentablayer :
%    ind = inside( obj, r, z1, z2 )
%  Input
%    r          :  radii
%    z1, z2     :  z-values
%  Output
%    ind        :  index to Green function to be used for interpolation

%  evaluate inside function of Green function objects
in = cellfun( @( g ) reshape( inside( g, varargin{ : } ), [], 1 ),  ...
                                           obj.g, 'UniformOutput', false );
%  nonzero elements of in
in = cell2mat( in );  [ row, col ] = find( in );

%  index to Green function objects
ind = zeros( size( in, 1 ), 1 );  
if ~isempty( row ),  ind( row ) = col;  end
