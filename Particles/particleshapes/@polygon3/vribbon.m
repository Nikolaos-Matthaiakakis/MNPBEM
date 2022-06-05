function [ p, up, lo ] = vribbon( obj, varargin )
%  VRIBBON - Extrude vertical ribbon.
%
%  Usage for obj = polygon3 :
%    [ p, up, lo ] = vribbon( obj, z, PropertyPairs )
%    [ p, up, lo ] = vribbon( obj,    PropertyPairs )
%  Input
%    z          :  z-values of vertical ribbon
%                    use default edge values if missing
%  PropertyName
%    'edge'     :  edge profile
%  Output
%    p          :  discretized vertical ribbon
%    up, lo     :  POLYGON3 for upper/lower ribbon boundary

%  handle different calling sequences
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ z, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end

%  cell arrays for output
[ p, up, lo ] = deal( cell( size( obj ) ) );
%  get options
op = getbemoptions( varargin{ : } );
%   edge functions
if isfield( op, 'edge' ),  obj = set( obj, 'edge', op.edge );  end
%  symmetry
if ~isfield( op, 'sym' ),  op.sym = [];  end

%  loop over polygons
for i = 1 : numel( obj )
  %  edge profile of ribbon
  fun = @( z ) hshift( obj( i ).edge, z );
  %  discretize ribbon
  if exist( 'z', 'var' )
    [ p{ i }, up{ i }, lo{ i } ] =  ...
      ribbon( obj( i ),               z, fun, op.sym, varargin{ : }  );
  else
    [ p{ i }, up{ i }, lo{ i } ] =  ...
      ribbon( obj( i ), obj( i ).edge.z, fun, op.sym, varargin{ : }  );
  end
end

%  put together particles and polygons
[ p, up, lo ] =  ...
  deal( vertcat( p{ : } ), vertcat( up{ : } ), vertcat( lo{ : } ) );


function [ p, up, lo ] = ribbon( obj, z, fun, sym, varargin )
%  RIBBON - Extrude vertical ribbon for a single polygon.

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
z( 1 : 2 : 2 * length( z ) ) = z;
z( 2 : 2 : end - 1 ) = 0.5 * ( z( 1 : 2 : end - 2 ) + z( 3 : 2 : end ) );
%  triangulate flat ribbon 
[ u, faces ] =  ...
  fvgrid( 1 : 2 : size( pos, 1 ), 1 : 2 : length( z ) );

%  transform ribbon positions
verts = [ pos( u( :, 1 ), 1 ),  ...
          pos( u( :, 1 ), 2 ), reshape( z( u( :, 2 ) ), [], 1 ) ];
%  apply shift function
shift = fun( verts( :, 3 ) );
%  displace vertices
verts( :, 1 ) = verts( :, 1 ) + shift .* vec( u( :, 1 ), 1 );
verts( :, 2 ) = verts( :, 2 ) + shift .* vec( u( :, 1 ), 2 );
    
%  save as particle
p = particle( verts, faces, varargin{ : } );

%  find point that is closest to first point of polygon
[ ~, ind ] = min( ( p.pos( :, 1 ) - pos( 1, 1 ) ) .^ 2 +  ...
                  ( p.pos( :, 2 ) - pos( 1, 2 ) ) .^ 2 );
%  make sure that normal vectors point into the right direction                
if dot( [ vec( 1, : ), 0 ], p.nvec( ind, : ) ) < 0
  p = flipfaces( p );
end

%  shift function
shift = @( z ) shiftbnd( obj.poly, fun( z ) );
%  polygon for upper/lower ribbon boundary
up = obj;  [ up.poly, up.z ] = deal( shift( max( z ) ), max( z ) );
lo = obj;  [ lo.poly, lo.z ] = deal( shift( min( z ) ), min( z ) );
