function tab = tabspace2( obj, p, varargin )
%  TABSPACE2 - Compute suitable grids for tabulated r and z-values.
%
%  Usage for obj = layerstructure :
%    tab = tabspace2( obj, p,         PropertyPair )
%    tab = tabspace2( obj, p, pt,     PropertyPair )
%  Input
%    p        :  particle or cell array of particles
%    pt       :  points   or cell array of points
%  PropertyName
%    'rmod'   :  'log' for logspace r-table (default) or 'lin' for linspace
%    'zmod'   :  'log' for logspace z-table (default) or 'lin' for linspace
%    'nr'     :  number of r-values for automatic grid
%    'nz'     :  number of z-values for automatic grid
%    'scale'  :  scale factor for automatic grid sizes
%    'range'  :  'full' for use full z-range starting at layer 
%                              bottom and/or top for automatic grid size
%    'output' :  graphical output of grids
%  Output
%    tab.r    :  tabulated radial values
%    tab.z1   :  tabulated z1-values
%    tab.z2   :  tabulated z2-values

%  handle different call sequences
if ~isempty( varargin ) && ~( isstruct( varargin{ 1 } ) || ischar( varargin{ 1 } ) )
  [ pt, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end
%  get options
op = getbemoptions( varargin{ : } );
%  scale factor
if ~isfield( op, 'scale' ), op.scale = 1.05;  end
%  number of layers
n = numel( obj.z ) + 1;

if ~iscell( p ),  p = { p };  end
%  positions
pos = cell( size( p ) );
%  loop over particles or points
for i = 1 : numel( p )
  %  try to add vertices for particles
  try
    pos{ i } = p{ i }.verts;
  catch
    pos{ i } = p{ i }.pos;
  end
end
%  put together particle positions to one array
[ pos1, pos2 ] = deal( vertcat( pos{ : } ) );  

%  handle additional point argument
if exist( 'pt', 'var' )
  %  point positions
  pos = cellfun( @( p ) pt.pos, p, 'UniformOutput', false );  
  %  put together point positions to one array
  pos1 = [ pos1; vertcat( pos{ : } ) ];  
end

%  get limits for radii and z-values
[ ir, iz1, iz2 ] = limits( obj, pos1, pos2 );
%  index to nonempty entries
ind = cellfun( @( z1 ) ~isempty( z1 ), iz1 );
%  adjust z-values
[ iz1( ind ), iz2( ind ) ] = cellfun(  ...
  @( z1, z2 ) adjust( obj, z1, z2, op ), iz1( ind ), iz2( ind ), 'UniformOutput', false );
                    
%  scale function for radii
fun = @( r ) max( mean( r ) + [ 1, -1 ] * 0.5 * op.scale * ( r( 1 ) - r( 2 ) ), 0 );
%  scale radii
ir( ind ) = cellfun( @( r ) fun( r ), ir( ind ), 'UniformOutput', false );
%  set to full range
if isfield( op, 'range' ) && strcmp( op.range, 'full' )
  ir( ind ) = cellfun( @( r ) [ 0, r( 2 ) ], ir( ind ), 'UniformOutput', false );
end

%  output array
tab = [];
%  number of radii and z-values
nr = 30;  if isfield( op, 'nr' ),  nr = op.nr;  end
nz = 30;  if isfield( op, 'nz' ),  nz = op.nz;  end
%  expand nz-values to layer size
if numel( nz ) == 1,  nz = repmat( nz, 1, n );  end

%  loop over layers
for i1 = 1 : n
for i2 = 1 : n
  if ~isempty( iz1{ i1, i2 } )
    %  radii
    r = [ ir{ i1, i2 }, nr ];
    %  z1 values
    z1 = [ iz1{ i1, i2 }, nz( i1 ) ];
    %  z2 values
    if numel( iz2{ i1, i2 } ) == 1
      z2 = iz2{ i1, i2 };
    else
      z2 = [ iz2{ i1, i2 }, nz( i2 ) ];
    end
    %  tabulated values
    tab = [ tab, tabspace1( obj, r, z1, z2, varargin{ : } ) ];
  end
end
end

%  plot TABSPACE ?
if isfield( op, 'output' ) && op.output
  %  find maximum of z-range
  rmax = max( arrayfun( @( tab ) max( tab.r ), tab ) );
  %  find minima and maxima of z-range
  zmin = min( arrayfun( @( tab ) min( [ tab.z1, tab.z2 ] ), tab ) );
  zmax = max( arrayfun( @( tab ) max( [ tab.z1, tab.z2 ] ), tab ) );
  %  z-values for plotting of r-values
  if numel( obj.z ) == 1
    z = obj.z + [ - 0.01, 0.01 ];
  else
    z = 0.5 * ( obj.z( 1 : end - 1 ) + obj.z( 2 : end ) );
    z = [ obj.z( 1 ) + 0.01, z, obj.z( end ) - 0.01 ];
  end
  %  increment
  incr = 0.8 / numel( obj.z );
  %  loop over TAB
  for i = 1 : numel( tab )
    %  index to layer within which z1 and z2 values are located
    ind1 = indlayer( obj, tab( i ).z1( 1 ) );
    ind2 = indlayer( obj, tab( i ).z2( 1 ) );
    %  plot r and z-values
    plot( ind2 - 1.0 + tab( i ).r / rmax, z( ind1 ), 'b.' );   hold on
    plot( ind2 - 0.9 + incr * ( ind1 - 1 ), tab( i ).z1, 'r.' );  
    plot( ind2 - 0.9 + incr * ( ind1 - 1 ), tab( i ).z2, 'm.' );  
  end
  %  plot x-grid
  for i = 1 : numel( obj.z )
    plot( [ 0, numel( obj.z ) ], obj.z( i ) * [ 1, 1 ], 'k:' );
  end
  %  plot y-grid
  for i = 0 : numel( obj.z )
    plot( [ i, i ], [ zmin, zmax ], 'k-' );
  end
  
  xlim( [ - 0.1, numel( obj.z ) + 0.1 ] );
  %  annotate plot
  xlabel( 'index to layer | normalized radii' );
  ylabel( 'z (nm)' );
  
  title( [ 'rmax = ', num2str( rmax ) ] );
end


function [ ir, iz1, iz2 ] = limits( obj, pos1, pos2 )
%  LIMITS - Limits for r and z values within different layers.

%  radial distance between points
r = misc.pdist2( pos1( :, 1 : 2 ), pos2( :, 1 : 2 ) );

%  z-value and layer index
z1 = pos1( :, 3 );  ind1 = indlayer( obj, z1 );
z2 = pos2( :, 3 );  ind2 = indlayer( obj, z2 );
%  allocate output arrays
[ ir, iz1, iz2 ] = deal( cell( numel( obj.z ) + 1 ) );

%  minmax function
fun = @( x ) [ min( x( : ) ), max( x( : ) ) ];
%  loop over layers
for i1 = 1 : numel( obj.z ) + 1
for i2 = 1 : numel( obj.z ) + 1
  if any( ind1 == i1 ) && any( ind2 == i2 )
    ir{  i1, i2 } = fun( r(  ind1 == i1, ind2 == i2 ) );
    iz1{ i1, i2 } = fun( z1( ind1 == i1 ) );
    iz2{ i1, i2 } = fun( z2( ind2 == i2 ) );
  end
end
end
