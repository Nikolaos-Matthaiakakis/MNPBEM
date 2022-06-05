function mat = refinematrix( p1, p2, varargin )
%  REFINEMATRIX - Refinement matrix for Green functions.
%
%  Usage :
%    mat = refinematrix( p1, p2, op )
%  Input
%    p1     :  discretized particle boundary 1
%    p2     :  discretized particle boundary 2
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
  %  distance between positions
  d = misc.pdist2( pos1, pos2( i2, : ) );
  %  subtract radius from distances to get approximate distance between
  %  POS1 and boundary elements
  d2 = bsxfun( @minus, d, rad2( i2 ) );  
  %  distances in units of boundary element radius
  if size( rad, 1 ) ~= 1
    id = bsxfun( @rdivide, d2, rad );
  else
    id = bsxfun( @rdivide, d2, rad( i2 ) );
  end
  %  diagonal elements and elements for refinement
  [ row1, col1 ] = find( d == 0 );
  [ row2, col2 ] = find( ( d2 < op.AbsCutoff | id < op.RelCutoff ) & d ~= 0 );
  %  set diagonal elements and elements for refinement
  mat = mat + sparse( row1, col1 + ind2( i - 1 ), 0 * col1 + 2, p1.n, p2.n ) +  ...
              sparse( row2, col2 + ind2( i - 1 ), 0 * col2 + 1, p1.n, p2.n );
  
end
