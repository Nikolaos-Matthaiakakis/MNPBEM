function obj = init( obj, p1, p2, varargin )
%  Initialize Green function.

%  positions of point and particle
obj.p1 = p1;  pos1 = p1.pos;
obj.p2 = p2;  pos2 = p2.pos;

%  options for Green function
op = getbemoptions( { 'green', 'greenret' }, varargin{ : } );
%  refinement matrix
ir = green.refinematrix( p1, p2, op );

%  derivative 'norm' or 'cart'
if isfield( op, 'deriv' ),  obj.deriv = op.deriv;  end
%  order of exp( 1i * k * r ) expansion
if isfield( op, 'order' ) && ~isempty( op.order )
  order = op.order;
else
  %  set default value
  order = 2;
end

%  index to refined elements
obj.ind = find( ir( : ) ~= 0 );
%  conversion table between matrix elements and refined elements
[ row, col ] = find( ir ); 
ind = sparse( row, col, 1 : numel( row ), p1.n, p2.n );
%  elements with refinement ?
if isempty( obj.ind ) || order == 0,  return;  end
%  initialize waitbar
iswaitbar = isfield( op, 'waitbar' ) && op.waitbar;
if iswaitbar,  multiWaitbar( 'Initializing greenret', 0, 'CanCancel', 'on' );  end

%  allocate arrays
g = zeros( numel( obj.ind ),      order + 1 );
if strcmp( obj.deriv, 'cart' )
  f = zeros( numel( obj.ind ), 3, order + 1 );
else
  f = zeros( numel( obj.ind ),    order + 1 );
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
  %  accumulate function
  fun = @( x, n ) accumarray( row, w .* ( x ) ) / factorial( n );
  
  %  measure positions with respect to centroids
  vec = p1.pos( face( row ), : ) - pos ;
  %  distance
  r = sqrt( dot( vec, vec, 2 ) );
  
  %  Green function
  for ord = 0 : order
    g( iface, ord + 1 ) = fun( r .^ ( ord - 1 ), ord );
  end
  
  %  inner product
  in = dot( vec, p1.nvec( face( row ), : ), 2 );  
  %  surface derivative of Green function
  switch obj.deriv
    case 'norm'
      %  loop over orders
      for ord = 0 : order
        f( iface, ord + 1 ) = fun( ( ord - 1 ) * in .* r .^ ( ord - 3 ), ord );
      end
    case 'cart'
      %  for r->0 the tangential derivatives vanish because the integrand
      %  is an odd function, here we avoid the limit r->0
      rr = max( r, 1e-4 * max( r ) );
      %  inner product
      in1 = dot( vec, p1.tvec1( face( row ), : ), 2 );       
      in2 = dot( vec, p1.tvec2( face( row ), : ), 2 );       
      %  loop over orders
      for ord = 0 : order
        %  normal derivative
        f( iface, 1, ord + 1 ) = fun( ( ord - 1 ) * in .* r .^ ( ord - 3 ), ord );
        %  tangential derivatives
        f( iface, 2, ord + 1 ) = fun( ( ord - 1 ) * in1 .* r .^ ord ./ rr .^ 3, ord );
        f( iface, 3, ord + 1 ) = fun( ( ord - 1 ) * in2 .* r .^ ord ./ rr .^ 3, ord );
        %  transform from tangential and normal vectors to Cartesian coordinates
        f( iface, :, ord + 1 ) =  ...
          bsxfun( @times, p1.nvec(  face, : ), f( iface, 1, ord + 1 ) ) +  ...
          bsxfun( @times, p1.tvec1( face, : ), f( iface, 2, ord + 1 ) ) +  ...
          bsxfun( @times, p1.tvec2( face, : ), f( iface, 3, ord + 1 ) );
      end      
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
    if multiWaitbar( 'Initializing greenret', find( face == reface ) / numel( reface ) )
      multiWaitbar( 'CloseAll' );  
      error( 'Initilialization of greenret stopped' );
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

  %  difference vector between face centroids
  vec0 = - bsxfun( @minus, pos1( nb, : ), pos2( face, : ) );
  %  distance
  r0 = sqrt( dot( vec0, vec0, 2 ) );
  
  %  Green function
  for ord = 0 : order
    g( iface, ord + 1 ) =  ...
        ( bsxfun( @minus, r, r0 ) .^ ord ./ r ) / factorial( ord ) * w;
  end

  %  surface derivative of Green function
  switch obj.deriv
    case 'norm'
      %  inner product
      in = bsxfun( @times, x, p1.nvec( nb, 1 ) ) +  ...
           bsxfun( @times, y, p1.nvec( nb, 2 ) ) +  ...
           bsxfun( @times, z, p1.nvec( nb, 3 ) );
      %  lowest order
      f( iface, 1 ) = - ( in ./ r .^ 3 ) * w;
      %  loop over orders
      for ord = 1 : order
        f( iface, ord + 1 ) = ( in .* (                                                      ...
          ( - bsxfun( @minus, r, r0 ) .^   ord       ./ ( r .^ 3 * factorial( ord     ) ) +  ...
              bsxfun( @minus, r, r0 ) .^ ( ord - 1 ) ./ ( r .^ 2 * factorial( ord - 1 ) ) ) ) ) * w;
      end
    case 'cart'
      %  vector integration function
      fun = @( f ) [ ( x .* f ) * w, ( y .* f ) * w, ( z .* f ) * w ];
      %  lowest order
      f( iface, :, 1 ) = - fun( 1 ./ r .^ 3 );
      %  loop over orders
      for ord = 1 : order
        f( iface, :, ord + 1 ) = fun(                                                      ...
          - bsxfun( @minus, r, r0 ) .^   ord       ./ ( r .^ 3 * factorial( ord     ) ) +  ...
            bsxfun( @minus, r, r0 ) .^ ( ord - 1 ) ./ ( r .^ 2 * factorial( ord - 1 ) ) );
      end        
  end            
end

  
%%  save refined elements
obj.g = g;
obj.f = f;
%  save options and order
[ obj.op, obj.order ] = deal( op, order );

%  additional refinement ?
if isfield( op, 'refun' ),  [ obj.g, obj.f ] = op.refun( obj, g, f );  end

%  close waitbar
if iswaitbar
  multiWaitbar( 'Initializing greenret', 'Close' );  
  drawnow;
end
