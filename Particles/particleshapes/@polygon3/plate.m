function [ p, obj ] = plate( obj, varargin )
%  PLATE - Make a plate out of polygons.
%
%  Usage for obj = polygon3 :
%    [ p, poly ] = plate( obj, PropertyPairs )
%  PropertyName
%    'dir'      :  direction of surface normals for plate
%    'hdata'    :  data array for Mesh2d
%    'options'  :  options for Mesh2d
%    'refun'    :  refine function
%    'edge'     :  edge profile
%    'sym'      :  symmetry
%  Output
%    p          :  discretized plate
%    poly       :  polygons for plate

%  get z-values of polygons
z = arrayfun( @( obj ) obj.z, obj );
%  make sure that all z-values are identical
[ z, ind ] = unique( misc.round( z, 8 ) );  assert( numel( ind ) == 1 );

%  option structure
op = getbemoptions( varargin{ : } );
%  override edge profile
if isfield( op, 'edge' ),  obj = set( obj, 'edge', op.edge );  end

%  refine functions of polygons
fun = arrayfun( @( obj ) obj.refun, obj, 'UniformOutput', false );
%  add refine function passed to PLATE
if isfield( op, 'refun' ),  fun{ end + 1 } = op.refun;  end

%  options passed to Mesh2d
if ~isfield( op, 'hdata'   ),  op.hdata   = struct;                     end
if ~isfield( op, 'options' ),  op.options = struct( 'output', false );  end
%  refine function
if ~all( cellfun( 'isempty', fun ) )
  op.hdata.fun = @( x, y, ~ ) refun( obj, x, y, fun );
end
%  symmetry
if ~isfield( op, 'sym' ),  op.sym = [];  end

%  get polygons
poly = arrayfun( @( obj ) obj.poly, obj, 'UniformOutput', false );
%  symmetrize polygons
poly1 = close( symmetry( horzcat( poly{ : } ), op.sym ) );
%  triangulate plate
[ verts, faces ] = polymesh2d( poly1,  ...
                             'hdata', op.hdata, 'options', op.options );
%  add additional boundary points to polygon at boundary
for i = 1 : numel( obj )
  obj( i ).poly = interp1( obj( i ).poly, verts );
  [ ~, obj( i ).poly ] = symmetry( obj( i ).poly, op.sym );
end

%  make particle
p = particle( [ verts, 0 * verts( :, 1 ) + obj( 1 ).z ], faces );
%  add midpoints
p = midpoints( p, 'flat' );
%  direction of plate normal
dir = 1;  if isfield( op, 'dir' ),  dir = op.dir;  end
%  make sure that normal vector point into right direction
if sign( sum( p.nvec( :, 3 ) ) ) ~= dir,  p = flipfaces( p ); end

%  index to polygon position 
ipoly = zeros( size( obj ) );
% minimum distance to polygons (for EDGESHIFT)
dmin = inf( size( p.verts2, 1 ), 1 );

%  loop over polygons
for i = 1 : numel( obj )
  %  add additional boundary points to polygon at boundary
  poly = interp1( obj( i ).poly, p.verts2( :, 1 : 2 ) );
  [ ~, poly ] = symmetry( poly, op.sym );
  %  index to vertices at boundary
  [ row, col ] = find(  ...
      bsxfun( @eq, p.verts2( :, 1 ), poly.pos( :, 1 ) .' ) &  ...
      bsxfun( @eq, p.verts2( :, 2 ), poly.pos( :, 2 ) .' ) );
  %  save first point on polygon
  ipoly( i ) = row( 1 );
  %  smooth polygon boundary and change boundary points
  poly = midpoints( poly, 'same' );
  p.verts2( row, 1 : 2 ) = poly.pos( col, : );
  
  %  distance to edges
  d = dist( poly, p.verts2( :, 1 : 2 ) );
  %  index to distances smaller than DMIN and update DMIN
  ind = d < dmin;  dmin( ind ) = d( ind );
  %  shift edges
  p.verts2( ind, 3 ) = z + vshift( obj( i ).edge, obj( i ).z, d( ind ) );
end

%  z-value of polygons
for i = 1 : numel( obj ),  obj( i ).z = p.verts2( ipoly( i ), 3 );  end
%  particle with midpoints
p = particle( p.verts2, p.faces2, varargin{ : } );


function h = refun( obj, x, y, fun )
%  REFUN - Refine function for Mesh2d toolbox.
%
%  Usage for obj = polygon3d :
%    h = refun( obj, x, y, fun )
%  Input
%    x, y   :  mesh points
%    fun    :  user-provided refine function 
%  Output
%    h      :  parameter that controls discretization of Mesh2d toolbox
%
%  The refine function is of the form fun(pos,d), where POS is the
%  position and D the distance(s) to the polygon(s).

%  position
pos = [ x( : ), y( : ), 0 * x( : ) + obj( 1 ).z ];
%  distance array
d = arrayfun(  ...
  @( obj ) dist( obj.poly, [ x( : ), y( : ) ] ), obj, 'UniformOutput', false );

%  index to non-empty refine functions
ind = ~cellfun( 'isempty', fun( 1 : numel( obj ) ) );  
%  discretization parameter
if ~isempty( ind )
  h = cellfun( @( fun, d ) fun( pos, d ), fun( ind ), d( ind ), 'UniformOutput', false );
  h = min( [ h{ : } ], [], 2 );
else
  h = inf;
end
%  refine function passed to PLATE
if numel( fun ) > numel( obj ),  h = min( [ h, fun{ end }( pos, d ) ], [], 2 ); end
