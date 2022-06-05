function obj = init( obj, varargin )
%  INIT - Initialize quadface object.

%  get BEM options
op = getbemoptions( { 'quadface' }, varargin{ : } );

%  number of integration points (radius, angle) for polar integration
if ~isfield( op, 'npol' ),  op.npol = [ 7, 5 ];            end
if numel( op.npol ) ~= 2,   op.npol = [ 1, 1 ] * op.npol;  end
%  save number of integration points
obj.npol = op.npol;

%%  triangle integration
%  default value for rule
if ~isfield( op, 'rule' );  op.rule = 18;  end
%  points and weights for triangle integration
[ obj.x, obj.y, obj.w ] = triangle_unit_set( op.rule );

%  refine triangles
if isfield( op, 'refine' )
  [ obj.x, obj.y, obj.w ] =  ...
    trisubdivide( obj.x, obj.y, obj.w, op.refine );
end

%%  polar triangle integration
%  radius and angle
[ x1, w1 ] = lglnodes( op.npol( 1 ) );  rho = 0.5 * ( x1 + 1 + 1e-6 );
[ x2, w2 ] = lglnodes( op.npol( 2 ) );  phi = ( 270 + 60 * x2 ) / 180 * pi;
%  rotation angle
phi0 = 120 / 180 * pi;

%  make 2d array
[ rho, phi ] = ndgrid( rho, phi );
[ rho, phi ] = deal( rho( : ), phi( : ) );
%  radius
rad = 1 ./ abs( 2 * sin( phi ) );
%  angles
phi = [ phi, phi + phi0, phi + 2 * phi0 ];

%  integration points in triangle
x = bsxfun( @times, cos( phi ), rho .* rad );  x = x( : );
y = bsxfun( @times, sin( phi ), rho .* rad );  y = y( : );
%  transform to unit triangle
[ x, y ] = deal( ( 1 - sqrt( 3 ) * x - y ) / 3,  ...
                 ( 1 + sqrt( 3 ) * x - y ) / 3 );
             
%  integration weights
w = w1( : ) * reshape( w2( : ), 1, [] );
%  integration weights for unit triangle
w = repmat( w( : ) .* rho .* rad .^ 2, 3, 1 );  w = w / sum( w );

%  save integration points and weights for polar triangle integration
[ obj.x3, obj.y3, obj.w3 ] = deal( x, y, w );

%%  polar quadrilateral integration
%  radius and angle
[ x1, w1 ] = lglnodes( op.npol( 1 ) );  rho = 0.5 * ( x1 + 1 + 1e-6 );
[ x2, w2 ] = lglnodes( op.npol( 2 ) );  phi = ( 90 + 45 * x2 ) / 180 * pi;
%  rotation angle
phi0 = pi / 2;

%  make 2d array
[ rho, phi ] = ndgrid( rho, phi );
[ rho, phi ] = deal( rho( : ), phi( : ) );
%  radius
rad = 1 ./ abs( sin( phi ) );
%  angles
phi = [ phi, phi + phi0, phi + 2 * phi0, phi + 3 * phi0 ];

%  integration points in quadrilateral
x = bsxfun( @times, cos( phi ), rho .* rad );  x = x( : );
y = bsxfun( @times, sin( phi ), rho .* rad );  y = y( : );
             
%  integration weights
w = w1( : ) * reshape( w2( : ), 1, [] );
%  integration weights for unit triangle
w = repmat( w( : ) .* rho .* rad .^ 2, 4, 1 );  w = 4 * w / sum( w );

%  save integration points and weights for polar quadrilateral integration
[ obj.x4, obj.y4, obj.w4 ] = deal( x, y, w );
