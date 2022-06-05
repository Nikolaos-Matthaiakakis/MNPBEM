function is = ismember( obj, layer, varargin )
%  ISMEMBER - Determines whether precomputed table is compatible with input.
%
%  Usage for obj = compgreentablayer :
%    is = ismember( obj, layer )
%    is = ismember( obj, layer, enei )
%    is = ismember( obj, layer, enei, p, pt )
%    is = ismember( obj, layer,       p, pt )
%  Input
%    layer  :  layer structure
%    enei   :  wavelengths of light in vacuum 
%  Output
%    is     :  TRUE if LAYER, ENEI and positions of P and PT are compatible
%              with precomputed Green functions, otherwise
%              COMPGREENRETLAYER should be re-initialized

%  handle calling sequences with and w/o wavelengths
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  is = cellfun( @( g )  ...
        ismember( g, layer, varargin{ 1 } ), obj.g, 'UniformOutput', false );
  varargin = varargin( 2 : end );
else
  is = cellfun( @( g ) ismember( g, layer ), obj.g, 'UniformOutput', false );
end
%  return if layer structures are not identical
if ~all( cell2mat( is ) ),  is = false;  return;  end

%  deal with additional P and/or PT arguments
if ~isempty( varargin )
  %  allocate array
  pos = cell( size( varargin ) );
  
  for i = 1 : numel( varargin )
    %  extract object
    p = varargin{ i };
    %  make to cell
    if ~iscell( p ),  p = { p };  end
    % %  particle or point positions
    % pos{ i } = cellfun( @( p ) p.pos, p, 'UniformOutput', false ); 
        
    %  positions
    pos2 = cell( size( p ) );
    %  loop over particles or points
    for j = 1 : numel( p )
      %  try to add vertices for particles
      try
        pos2{ j } = p{ j }.verts;
      catch
        pos2{ i } = p{ j }.pos;
      end
    end
    
    %  put together particle or point positions to one array
    pos{ i } = vertcat( pos2{ : } );  
  end
  %  positions
  [ pos1, pos2 ] = deal( pos{ 1 } );
  %  add additional compoint positions
  if numel( pos ) == 2,  pos1 = [ pos1; pos{ 2 } ];  end
    
  %  distances
  r = misc.pdist2( pos1( :, 1 : 2 ), pos2( :, 1 : 2 ) );
  %  expand z-values
  z1 = repmat( pos1( :, 3 ), 1, size( pos2, 1 ) );
  z2 = repmat( pos2( :, 3 ), 1, size( pos1, 1 ) ) .';
  %  index to Green function to be used for interpolation
  ind = inside( obj, r( : ), z1( : ), z2( : ) );
  
  %  make sure that all points can be interpolated
  is = ~any( ind == 0 );  
end