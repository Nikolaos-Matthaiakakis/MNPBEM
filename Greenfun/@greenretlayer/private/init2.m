function obj = init2( obj, ir, op )
%  INIT2 - Initialize off-diagonal elements for Green function object.
%          Refinement for full derivative.
%  
%  Usage for obj = greenretlayer :
%    obj = init2( obj, ir, op )
%  Input
%    ind    :  index to elements with refinememnt
%    op     :  options structure

%  initialize waitbar
iswaitbar = isfield( op, 'waitbar' ) && op.waitbar;
if iswaitbar
  multiWaitbar( 'Initializing greenretlayer', 0,  ...
         'Color', [ 0.4, 0.1, 0.5 ], 'CanCancel', 'on' );  
end

%  conversion between index and matrix
ind = zeros( size( ir ) );
ind( ir == 1 ) = 1 : length( obj.ind );
%  allocate arrays for radii and z-values for refinement
obj.ir = [];
obj.iz = [];
%  allocate refinement arrays
[ i1, g, f1, f2, fz ] = deal( [], [], [], [], [] );

%  faces to be refined
reface = find( any( ind ~= 0, 1 ) );
%  positions and weights for boundary element integration
[ postab, wtab ] = quad( obj.p2, reface );
%  find non-zero elements
[ row, col, wtab ] = find( wtab );

%  loop over faces to be refined
for face = reshape( reface, 1, [] )
    
  if iswaitbar && mod( find( face == reface ), fix( numel( reface ) / 20 ) ) == 0
    if multiWaitbar( 'Initializing greenretlayer',  ...
                           find( face == reface ) / numel( reface ) )
      multiWaitbar( 'CloseAll' );  
      error( 'Initilialization of greenretlayer stopped' );
    end
  end    
     
  %  index to neighbour faces 
  nb = find( ind( :, face ) ~= 0 );
  %  index to refinement array and to face in reface list
  [ iface, face2 ] = deal( ind( nb, face ), find( reface == face ) );   
  %  positions and weights for boundary element integration
  pos = postab( col( row == face2 ), : );
  w = reshape( wtab( row == face2 ), [], 1 );   
  
  %  shape function and vertices for boundary element
  [ s, verts ] = deal( shapefunction( obj.p2, face ), vertices( obj.p2, face ) );  
  %  distances between face centroids and vertices
  [ r0, z0, d0, ~, ~ ] = dist( obj, obj.p1.pos( nb, : ), verts ); 
  [ ~,  z,  d,  x, y ] = dist( obj, obj.p1.pos( nb, : ), pos   ); 
  %  z-values of face centroids and vertices
  z1 = repmat( round( obj.layer, obj.p1.pos( nb, 3 ) ), 1, size( verts, 1 ) );
  z2 = repmat( round( obj.layer, verts( :, 3 ) ), 1, numel( nb ) ) .';
  %  add radii and z-values to table
  obj.ir = [ obj.ir; r0( : ) ];
  obj.iz = [ obj.iz; z1( : ), z2( : ) ];

  %  loop over shape elements
  for i = 1 : size( s, 2 )
    %  indices
    i1 = [ i1; iface ];
    %  Green functions at vertices
    g0  =   d0( :, i )                      * s( :, i ) .';
    fr0 = ( d0( :, i ) .^ 3 ./ r0( :, i ) ) * s( :, i ) .';
    fz0 = ( d0( :, i ) .^ 3 ./ z0( :, i ) ) * s( :, i ) .';
    %  add to Green functions
    g  = [ g;  ( g0 ./ d ) * w ];
    f1 = [ f1; ( fr0 .* x ./ d .^ 3 ) * w ];
    f2 = [ f2; ( fr0 .* y ./ d .^ 3 ) * w ];
    fz = [ fz; ( fz0 .* z ./ d .^ 3 ) * w ];
  end
end

%  save Green function arrays
obj.ig  = sparse( i1, 1 : numel( obj.ir ), g  );
obj.if1 = sparse( i1, 1 : numel( obj.ir ), f1 );
obj.if2 = sparse( i1, 1 : numel( obj.ir ), f2 );
obj.ifz = sparse( i1, 1 : numel( obj.ir ), fz );

%  close waitbar
if iswaitbar
  multiWaitbar( 'Initializing greenretlayer', 'Close' );  
  drawnow;  
end


function [ r, z, d, x, y ] = dist( obj, pos1, pos2 )
%  DIST - Difference positions.

layer = obj.layer;
%  difference vector between face centroids and integration points 
x = bsxfun( @minus, pos1( :, 1 ), pos2( :, 1 ) .' );
y = bsxfun( @minus, pos1( :, 2 ), pos2( :, 2 ) .' );
%  minimum distance to layer
z = bsxfun( @plus, round( obj.layer, mindist( obj.layer, pos1( :, 3 ) ) ),  ...
                   round( obj.layer, mindist( obj.layer, pos2( :, 3 ) ) ) .' );
                  
%  radii and distances between positions
r = sqrt( x .^ 2 + y .^ 2 );  r = max( layer.rmin, r );
d = sqrt( r .^ 2 + z .^ 2 );  
