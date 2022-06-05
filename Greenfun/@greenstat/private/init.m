function obj = init( obj, varargin )
%  Initialize Green function.

%  positions of point and particle
p1 = obj.p1;  pos1 = p1.pos;
p2 = obj.p2;  

%  options for Green function
op = getbemoptions( { 'green', 'greenstat' }, varargin{ : } );
%  refinement matrix
ir = green.refinematrix( p1, p2, op );

%  derivative 'norm' or 'cart'
if isfield( op, 'deriv' ),  obj.deriv = op.deriv;  end

%  index to refined elements
obj.ind = find( ir( : ) ~= 0 );
%  conversion table between matrix elements and refined elements
[ row, col ] = find( ir ); 
ind = sparse( row, col, 1 : numel( row ), p1.n, p2.n );
%  elements with refinement ?
if isempty( obj.ind ),  return;  end
%  initialize waitbar
iswaitbar = isfield( op, 'waitbar' ) && op.waitbar;
if iswaitbar,  multiWaitbar( 'Initializing greenstat', 0, 'CanCancel', 'on' );  end

%  allocate refinement arrays
g = zeros( length( obj.ind ), 1 );
if strcmp( obj.deriv, 'cart' )
  f = zeros( length( obj.ind ), 3 );
else
  f = zeros( length( obj.ind ), 1 );
end

%%  diagonal elements
%  refine diagonal elements
if any( ir( : ) == 2 )
  %  index to diagonal elements
  %    in case of mirror symmetry D is not a square matrix
  [ face, face2 ] = find( ir == 2 );
  %  index to refinement array
  iface = ind( sub2ind( size( ind ), face, face2 ) );
  %  integration points and weights for polar integration
  [ pos, w, row ] = quadpol( p2, face2 );  
  %  expand vector
  expand = @( x ) subsref( x( face, : ), substruct( '()', { row, ':' } ) );
  
  %  measure positions with respect to centroids
  vec = expand( p1.pos ) - pos ;
  %  distance
  r = sqrt( dot( vec, vec, 2 ) );
  %  save Green function
  g( iface ) = accumarray( row, w ./ r );
  
  %  surface derivative of Green function
  f( iface, 1 ) = - accumarray( row, w .* dot( vec, expand( p1.nvec ), 2 ) ./ r .^ 3 );
  %  expand for Cartesian coordinates
  if strcmp( obj.deriv, 'cart' ) 
    %  for r->0 the tangential derivatives vanish because the integrand is
    %  an odd function, here we avoid the limit r->0
    rr = max( r, 1e-4 * max( r ) );
    %  tangential derivatives
    f( iface, 2 ) = - accumarray( row, w .* dot( vec, expand( p1.tvec1 ), 2 ) ./ rr .^ 3 );
    f( iface, 3 ) = - accumarray( row, w .* dot( vec, expand( p1.tvec2 ), 2 ) ./ rr .^ 3 );
    %  transform from tangential and normal vectors to Cartesian coordinates
    f( iface, : ) = bsxfun( @times, p1.nvec(  face, : ), f( iface, 1 ) ) +  ...
                    bsxfun( @times, p1.tvec1( face, : ), f( iface, 2 ) ) +  ...
                    bsxfun( @times, p1.tvec2( face, : ), f( iface, 3 ) );
  end
end

%%  offdiagonal elements
%  faces to be refined
reface = find( any( ir == 1, 1 ) );
%  positions and weights for boundary element integration
[ postab, wtab ] = quad( p2, reface );
%  find non-zero elements
[ row, ~, wtab ] = find( wtab );

%  group integration positions and weights in cell array
r1   = accumarray( row, postab( :, 1 ), [], @( x ) { x } );
r2   = accumarray( row, postab( :, 2 ), [], @( x ) { x } );
r3   = accumarray( row, postab( :, 3 ), [], @( x ) { x } );
wtab = accumarray( row, wtab,           [], @( x ) { x } );
%  concatenate integration positions to vector
postab = cellfun( @( r1, r2, r3 ) [ r1, r2, r3 ], r1, r2, r3, 'uniform', 0 );

%  loop over faces to be refined
for face = reshape( reface, 1, [] )
    
  if iswaitbar && mod( find( face == reface ), fix( numel( reface ) / 20 ) ) == 0
    if multiWaitbar( 'Initializing greenstat', find( face == reface ) / numel( reface ) )
      multiWaitbar( 'CloseAll' );  
      error( 'Initilialization of greenstat stopped' );
    end
  end    
     
  %  index to neighbour faces 
  nb = find( ir( :, face ) == 1 );
  %  index to refinement array and to face in reface list
  [ iface, face2 ] = deal( ind( nb, face ), find( reface == face ) );  
  %  positions and weights for boundary element integration
  [ pos, w ] = deal( postab{ face2 }, wtab{ face2 } );  
  
  %  difference vector between face centroid and integration points 
  x = bsxfun( @minus, pos1( nb, 1 ), pos( :, 1 ) .' );
  y = bsxfun( @minus, pos1( nb, 2 ), pos( :, 2 ) .' );
  z = bsxfun( @minus, pos1( nb, 3 ), pos( :, 3 ) .' );
  %  distance
  r = sqrt( x .^ 2 + y .^ 2 + z .^ 2 );
  %  Green function
  g( iface ) = ( 1 ./ r ) * w;
  
  %  derivative of Green function
  if strcmp( obj.deriv, 'cart' )
    f( iface, : ) =  ...
        - [ ( x ./ r .^ 3 ) * w, ( y ./ r .^ 3 ) * w, ( z ./ r .^ 3 ) * w ];
  else
    f( iface ) = - ( bsxfun( @times, x ./ r .^ 3, p1.nvec( nb, 1 ) ) +  ...
                     bsxfun( @times, y ./ r .^ 3, p1.nvec( nb, 2 ) ) +  ...
                     bsxfun( @times, z ./ r .^ 3, p1.nvec( nb, 3 ) ) ) * w;
  end
end

%%  save refined elements
obj.g = g;
obj.f = f;
%  save options
obj.op = op;

%  additional refinement ?
if isfield( op, 'refun' ),  [ obj.g, obj.f ] = op.refun( obj, g, f );  end

%  close waitbar
if iswaitbar
  multiWaitbar( 'Initializing greenstat', 'Close' );  
  drawnow;  
end
