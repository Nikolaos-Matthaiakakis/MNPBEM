function [ p, in, out ] = hribbon( obj, d, varargin )
%  HRIBBON - Make horizontal ribbon.
%
%  Usage for obj = polygon3 :
%    [ p, in, out ] = vribbon( obj, d, PropertyPairs )
%  Input
%    d          :  d-values of horizontal ribbon
%  PropertyPair
%    'dir'      :  direction of surface normals for ribbon
%  Output
%    p          :  discretized horizontal ribbon
%    in, out    :  POLYGON3 for inner/outer ribbon boundary

%  cell arrays for output
[ p, in, out ] = deal( cell( size( obj ) ) );
%  get options
op = getbemoptions( varargin{ : } );
%   default value for direction and symmetry
if ~isfield( op, 'dir' ),  op.dir = 1;  end
if ~isfield( op, 'sym' ),  op.sym = []; end

%  loop over polygons
for i = 1 : numel( obj )
  %  discretize ribbon
  [ p{ i }, in{ i }, out{ i } ] =  ...
    ribbon( obj( i ), d, op.dir, op.sym, varargin{ : }  );
end

%  put together particles and polygons
[ p, in, out ] =  ...
  deal( vertcat( p{ : } ), vertcat( in{ : } ), vertcat( out{ : } ) );


function [ p, in, out ] = ribbon( obj, d, dir, sym, varargin )
%  RIBBON - Make horizontal ribbon for a single polygon.

%  smoothened polygon
poly = midpoints( obj.poly );
%  handle symmetry
if ~isempty( sym )
  %  symmetrize polygon
  poly = symmetry( poly, sym );
  %  remove origin for xy-symmetry
  if strcmp( sym, 'xy') && all( poly.pos( end, : ) == 0 )
    poly.pos = poly.pos( 1 : end - 1, : );
  end
end
%  positions and normal vector of polygon
[ pos, vec ] = deal( poly.pos, norm( poly ) );
%  close contour ?
if isempty( sym ) || ~all( abs( prod( pos( [ 1, end ], : ), 2 ) ) < 1e-6 )
  pos = [ pos; pos( 1, : ) ];
  vec = [ vec; vec( 1, : ) ];
end

%  extend z-values of edge for midpoints
d( 1 : 2 : 2 * length( d ) ) = d;
d( 2 : 2 : end - 1 ) = 0.5 * ( d( 1 : 2 : end - 2 ) + d( 3 : 2 : end ) );
%  triangulate flat ribbon 
[ u, faces ] =  ...
  fvgrid( 1 : 2 : size( pos, 1 ), 1 : 2 : length( d ) );

%  face vertices
[ x, y ] = deal( zeros( size( pos, 1 ), numel( d ) ) ); 
%  loop over displacements
for i = 1 : length( d )
  [ ~, dist ] = shiftbnd( poly, d( i ) );  
  %  deal with closed polygons
  if numel( dist ) ~= size( pos, 1 ),  dist = [ dist; dist( 1 ) ];  end
  %  displace ribbon vertices
  x( :, i ) = pos( :, 1 ) + dist .* vec( :, 1 ); 
  y( :, i ) = pos( :, 2 ) + dist .* vec( :, 2 );
end

%  assemble vertices
verts = [ x( sub2ind( size( x ), u( :, 1 ), u( :, 2 ) ) ),  ...
          y( sub2ind( size( x ), u( :, 1 ), u( :, 2 ) ) ) ];
%  save as particle
p = particle( [ verts, 0 * verts( :, 1 ) + obj.z ], faces, varargin{ : } );
%  make sure that normal vector point into right direction
if sign( sum( p.nvec( :, 3 ) ) ) ~= dir,  p = flipfaces( p ); end

%  shift function
shift = @( d ) shiftbnd( obj.poly, d );
%  polygon for upper/lower ribbon boundary
in  = obj;  [ in. poly, in. z ] = deal( shift( min( d ) ), obj.z );
out = obj;  [ out.poly, out.z ] = deal( shift( max( d ) ), obj.z );

