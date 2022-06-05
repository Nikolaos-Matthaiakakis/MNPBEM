function [ G, Fr, Fz, pos ] = green( obj, enei, r, z1, z2 )
%  GREEN - Compute reflected potential and derivatives for layer structure.  
%    Integration path in complex plane according to 
%    M. Paulus et al., PRE 62, 5797 (2000).
%
%  Usage for obj = layerstructure :
%    [ G, Fr, Fz, pos ] = green( obj, enei, r, z1, z2 )
%  Input
%    enei   :  wavelength of light in vacuum
%    r      :  radial distance between points
%    z1     :  z-values for position where potential is computed
%    z2     :  z-values for position of exciting charge or current
%  Output
%    G          :  reflected Green function 
%    Fr         :  derivative of Green function in radial direction
%    Fz         :  derivative of Green function in z-direction
%    pos        :  expanded arrays for radii and heights
%
%  If the sizes of the input arrays r, z1, z2 are identical, the direct
%  product .* of the output arrays is taken, otherwise the outer product.

%  round radii and z-values 
r = max( r, obj.rmin );  [ z1, z2 ] = round( obj, z1, z2 );
%  save positions in structure
pos = struct( 'r', r, 'z1', z1, 'z2', z2 );
%  indices to layers
pos.ind1 = indlayer( obj, z1 );
pos.ind2 = indlayer( obj, z2 );

%  positions (use inner or outer multiplication function private/mul)
[ r, z1, z2 ] = deal( mul( r,      mul( z1 .^ 0, z2 .^ 0 ) ),  ...
                      mul( r .^ 0, mul( z1,      z2 .^ 0 ) ),  ...
                      mul( r .^ 0, mul( z1 .^ 0, z2      ) ) );
%  minimal distance to layers
zmin = reshape( mindist( obj, z1( : ) ) + mindist( obj, z2( : ) ), size( r ) );

%  size of integrand
n1 = numel( r );
% initial vector
y1 = zeros( 15 * n1, 1 );
%  solve differential equation (semi-ellipse in complex kr-plane)
[ ~, y1 ] = ode45(  ...
  @( x, y ) ( fun( obj, enei, x, pos, 1 ) ), [ 0, 1e-3, pi ], y1, obj.op );

%  determine integration path in complex plane
ind2 = find( zmin( : ) >= r( : ) / obj.ratio );
ind3 = find( zmin( : ) <  r( : ) / obj.ratio );
%  initial vector
n2 = numel( ind2 );  y2 = zeros( 15 * n2, 1 );
n3 = numel( ind3 );  y3 = zeros( 15 * n3, 1 );

%  integration along real axis
if ~isempty( ind2 )
  [ ~, y2 ] = ode45( @( x, y ) ( fun( obj, enei, x, pos, 2, ind2 ) ),  ...
                                            [ 1, 1e-3, 1e-10 ], y2, obj.op );
end
%  integration along imaginary axis
if ~isempty( ind3 )
  [ ~, y3 ] = ode45( @( x, y ) ( fun( obj, enei, x, pos, 3, ind3 ) ),  ...
                                           [ 1, 1e-3, 1e-10 ], y3, obj.op );
end

%  get field names
names = fieldnames( reflection( obj, enei, 0, pos ) );
%  index of output file
num1 = @( iname, i ) ( ( iname - 1 ) * 3 + ( i - 1 ) ) * n1 + ( 1 : n1 );
num2 = @( iname, i ) ( ( iname - 1 ) * 3 + ( i - 1 ) ) * n2 + ( 1 : n2 );
num3 = @( iname, i ) ( ( iname - 1 ) * 3 + ( i - 1 ) ) * n3 + ( 1 : n3 );

%  save expanded arrays for radii and heights
pos = struct( 'r', r, 'z1', z1, 'z2', z2, 'zmin', zmin );
%  loop over field names
for i = 1 : length( names )
  %  Green functions from semi-elliplse
  g  = y1( end, num1( i, 1 ) );
  fr = y1( end, num1( i, 2 ) );
  fz = y1( end, num1( i, 3 ) );
  %  Green functions from integration along real axis
  if ~isempty( ind2 )
    g(  ind2 ) = g(  ind2 ) + y2( end, num2( i, 1 ) );  
    fr( ind2 ) = fr( ind2 ) + y2( end, num2( i, 2 ) );
    fz( ind2 ) = fz( ind2 ) + y2( end, num2( i, 3 ) );
  end
  %  Green functions from integration along imaginary axis
  if ~isempty( ind3 )
    g(  ind3 ) = g(  ind3 ) + y3( end, num3( i, 1 ) );
    fr( ind3 ) = fr( ind3 ) + y3( end, num3( i, 2 ) );
    fz( ind3 ) = fz( ind3 ) + y3( end, num3( i, 3 ) );
  end
  %  add to Green function
  G.(  names{ i } ) = squeeze( reshape( g,  size( r ) ) );
  Fr.( names{ i } ) = squeeze( reshape( fr, size( r ) ) );
  Fz.( names{ i } ) = squeeze( reshape( fz, size( r ) ) );
end


function y = fun( obj, enei, x, pos, key, varargin )
%  FUN - Integration path.

%  wavenumber of light in vacuum
k0 = 2 * pi / enei;
%  wavenumbers in media
%  wavenumber in media
[ ~, k ] = cellfun( @( eps ) ( eps( enei ) ), obj.eps );

%  large half-axis
k1max = max( real( k ) ) + k0;

switch key
  case 1
    %  semi-ellipse
    kr = k1max * ( 1 - cos( x ) - 1i * obj.semi * sin( x ) );
    %  compute Green function and derivatives
    y = k1max * ( sin( x ) - 1i * obj.semi * cos( x ) ) *  ...
              intbessel( obj, enei, kr, pos, varargin{ : } );
  case 2
    %  real kr-axis
    kr = 2 * k1max / x;
    %  compute Green function and derivatives
    y = - 2 * k1max * intbessel( obj, enei, kr, pos, varargin{ : } ) / x ^ 2;
  case 3
    %  imaginary kr-axis
    kr = 2 * k1max * ( 1 - 1i + 1i / x );
    %  compute Green function and derivatives
    y = - 2i * k1max * inthankel( obj, enei, kr, pos, varargin{ : } ) / x ^ 2;
end
                                
                                