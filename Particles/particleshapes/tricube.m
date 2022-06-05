function p = tricube( n, varargin )
%  TRICUBE - Cube particle with rounded edges.
%
%  Usage :
%    p = tricube( n      )
%    p = tricube( n, len )
%    p = tricube( n,      PropertyPair )
%    p = tricube( n, len, PropertyPair )
%  Input
%    n      :  grid size
%    len    :  length of cube edges
%  PropertyPair
%    'e'    :  round-off parameter for edges, default value 0.25

%  deal with different calling sequences
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ len, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
else
  len = 1;
end
%  make LEN an array ?
if numel( len ) ~= 3,  len = repmat( len, 1, 3 );  end
%  extract input
op = getbemoptions( varargin{ : } );
%  rounding-off parameter
if ~isfield( op, 'e' ),  op.e = 0.25;  end

%  discretize single side of cube
[ x, y, faces ] = square( n, op.e );
%  z-value
z = 0.5 * ones( size( x ) );

%  put together cube sides
p = vertcat( particle( [  x,  y,  z ], faces ),  ...
             particle( [  y,  x, -z ], faces ),  ...
             particle( [  y,  z,  x ], faces ),  ...
             particle( [  x, -z,  y ], faces ),  ...
             particle( [  z,  x,  y ], faces ),  ...
             particle( [ -z,  y,  x ], faces ) );
%  remove duplicate vertices
p = clean( p );
       
%  vertex positions in spherical coordinates
[ phi, theta ] =  ...
  cart2sph( p.verts2( :, 1 ), p.verts2( :, 2 ), p.verts2( :, 3 ) );
%  signed sinus and cosinus
isin = @( x ) sign( sin( x ) ) .* abs( sin( x ) ) .^ op.e;
icos = @( x ) sign( cos( x ) ) .* abs( cos( x ) ) .^ op.e;
%  use super-sphere for rounding-off edges
x = 0.5 * icos( theta ) .* icos( phi );
y = 0.5 * icos( theta ) .* isin( phi );
z = 0.5 * isin( theta );

%  make particle object
p = scale( particle( [ x, y, z ], p.faces2, varargin{ : } ), len );


function [ x, y, faces ] = square( n, e )
%  SQUARE - Triangulate square.

u = linspace( - 0.5 ^ e, 0.5 ^ e, n );
%  grid
[ verts, faces ] = fvgrid( u, u );
%  spacing for grid
x = sign( verts( :, 1 ) ) .* ( abs( verts( :, 1 ) ) ) .^ ( 1 / e );
y = sign( verts( :, 2 ) ) .* ( abs( verts( :, 2 ) ) ) .^ ( 1 / e );


      