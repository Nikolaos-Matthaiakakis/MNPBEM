function mat = refinematrixlayer( p1, p2, layer, varargin )
%  REFINEMATRIXLAYER - Refinement matrix for layer structres.
%
%  Usage :
%    mat = refinematrixlayer( p1, p2, layer, op )
%  Input
%    p1     :  discretized particle boundary 1
%    p2     :  discretized particle boundary 2
%    layer  :  layer structure
%    op     :  option matrix
%  Output
%    mat    :  refinement matrix
%                2 - diagonal elements
%                1 - off-diagonal elements for refinement
%
%  The option structure can contain the following elements
%    'AbsCutoff'   :  absolute distance for integration refinement  
%    'RelCutoff'   :  relative distance for integration refinement
%    'memsize'     :  deal at most with matrices of size MEMSIZE


op = getbemoptions( varargin{ : } );
%  set default value for absolute and relative cutoff 
if ~isfield( op, 'AbsCutoff' ),  op.AbsCutoff = 0;  end
if ~isfield( op, 'RelCutoff' ),  op.RelCutoff = 0;  end
if ~isfield( op, 'memsize'   ),  op.memsize = 2e7;  end

%  positions of points or particles
[ pos1, pos2 ] = deal( p1.pos, p2.pos );
%  boundary element radius
rad2 = misc.bradius( p2 ) .';
%  radius for relative distances
%    try to use boundary radius of first particle (fails for COMPOINT)
try
  rad = misc.bradius( p1 );
catch
  rad = rad2;
end  

%  allocate output array
mat = sparse( p1.n, p2.n );

%  work through full matrix size N1 x N2 in portions of MEMSIZE
ind2 = 0 : fix( op.memsize / p1.n ) : p2.n;
if ind2( end ) ~= p2.n,  ind2 = [ ind2, p2.n ];  end

%  loop over portions
for i = 2 : numel( ind2 )
  %  index to positions
  i2 = ( ind2( i - 1 ) + 1 ) : ind2( i );
  %  radial distance between points
  r = misc.pdist2( pos1( :, 1 : 2 ), pos2( i2, 1 : 2 ) );
  %  minimum distance to layer
  z = bsxfun( @plus, mindist( layer, pos1(  :, 3 ) ),  ...
                     mindist( layer, pos2( i2, 3 ) ) .' );               
  %  distance
  d = sqrt( r .^ 2 + z .^ 2 );  
  %  subtract radius from distances to get approximate distance between
  %  POS1 and boundary elements
  d2 = bsxfun( @minus, d, rad2( i2 ) );  
  %  distances in units of boundary element radius
  if size( rad, 1 ) ~= 1
    id = bsxfun( @rdivide, d2, rad );
  else
    id = bsxfun( @rdivide, d2, rad( i2 ) );
  end
  
  %  elements for refinement
  [ row, col ] = find( d2 < op.AbsCutoff | id < op.RelCutoff );
  mat = mat + sparse( row, col + ind2( i - 1 ), 0 * row + 1, p1.n, p2.n );
  %  diagonal boundary elements
  if numel( pos1 ) == numel( pos2 ) && all( reshape( pos1 == pos2, [], 1 ) )
    ind = ( row == col + ind2( i - 1 ) );
    %  diagonal elements
    mat = mat + sparse( row( ind ), col( ind ) + ind2( i - 1 ), 0 * row( ind ) + 1, p1.n, p2.n );
  end  
end
