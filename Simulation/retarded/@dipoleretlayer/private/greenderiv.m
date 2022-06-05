function [ G, F ] = greenderiv( obj, pos1, pos2 )
%  GREENDERIV - Green function and derivatives.
%
%  Usage for obj = dipoleretlayer :
%    [ G, Fr, Fz ] = greenderiv( obj, pos1, pos2 )
%  Input
%    pos1   :  positions of particle of dimension
%    pos2   :  dipole positions      of dimension
%  Output
%    G      :  reflected Green functions
%    F      :  derivatives of Green functions

%  avoid difficulties with diagonal components
%    In particular for the self-interaction of the dipoles we have to be
%    careful with the limits r' -> r.  The present implementation is
%    somewhat dirty and should be improved in the future.
if numel( pos1 ) == numel( pos2 ) && all( pos1( : ) == pos2( : ) )
  pos2 = bsxfun( @plus, pos2, [ obj.layer.rmin, 0, 0 ] );  
end

%  difference between positions
x = bsxfun( @minus, pos1( :, 1 ), pos2( :, 1 ) .' );
y = bsxfun( @minus, pos1( :, 2 ), pos2( :, 2 ) .' );
%  radial distance of positions
r = sqrt( x .^ 2 + y .^ 2 );
%  z-components 
z1 = repmat( pos1( :, 3 ), 1, size( r, 2 ) );
z2 = repmat( pos2( :, 3 ), 1, size( r, 1 ) ) .';

%  minimal radial distance and small quantity for numerical differentiation
[ rmin, eta ] = deal( obj.layer.rmin, 1e-6 );
%  index to zero distances
ind = r < rmin;
%  set minimal distance to RMIN
r( ind ) = rmin;
%  unit vector
[ x, y ] = deal( x ./ r, y ./ r );

%  interpolate tabulated Green function
[ G, Fr, F1 ] = interp( obj.tab, r( : ), z1( : ), z2( : ) );

%  use finite differences for additional radial derivatives
[ ~, fr, fz ] = interp( obj.tab, r( : ) + eta, z1( : ), z2( : ) );
%  higher-order radial derivatives
Frr = sderiv( Fr, fr, eta );
Fr1 = sderiv( F1, fz, eta );

%  use finite differences for additional z-derivatives
[ g, fr, fz ] = interp( obj.tab, r( : ), z1( : ), z2( : ) + eta );
%  higher-order z-derivatives
F2  = sderiv( G,  g,  eta );
Fr2 = sderiv( Fr, fr, eta );
F12 = sderiv( F1, fz, eta );

%  field names
names = fieldnames( G );
%  reshape function
fun = @( x ) reshape( x, size( r ) );

%  loop over field names
for i = 1 : numel( names )
  %  Green funczions
  G.( names{ i } ) = fun( G.( names{ i } ) );
  %   G.x',  G.y'
  F{ 1, 2 }.( names{ i } ) = - fun( Fr.( names{ i } ) ) .* x; 
  F{ 1, 3 }.( names{ i } ) = - fun( Fr.( names{ i } ) ) .* y;  
  %  G.x, G.y, G.1, G.2
  F{ 2, 1 }.( names{ i } ) =   fun( Fr.( names{ i } ) ) .* x; 
  F{ 3, 1 }.( names{ i } ) =   fun( Fr.( names{ i } ) ) .* y;
  F{ 4, 1 }.( names{ i } ) =   fun( F1.( names{ i } ) );
  F{ 1, 4 }.( names{ i } ) =   fun( F2.( names{ i } ) );
  %  G.xx', Gxy', G.yx', G.yy'
  F{ 2, 2 }.( names{ i } ) = - fun( Fr. ( names{ i } ) ) .* y .^ 2 ./ r  ...
                             - fun( Frr.( names{ i } ) ) .* x .^ 2;
  F{ 2, 3 }.( names{ i } ) = - fun( Fr. ( names{ i } ) ) .* x .* y ./ r  ...
                             - fun( Frr.( names{ i } ) ) .* x .* y;          
  F{ 3, 3 }.( names{ i } ) = - fun( Fr. ( names{ i } ) ) .* x .^ 2 ./ r  ...
                             - fun( Frr.( names{ i } ) ) .* y .^ 2;
  F{ 3, 2 }.( names{ i } ) = - fun( Fr. ( names{ i } ) ) .* x .* y ./ r  ...
                             - fun( Frr.( names{ i } ) ) .* x .* y;                                     
  %  G.x2, G.y2, G.1x', G.1y'                           
  F{ 2, 4 }.( names{ i } ) =   fun( Fr2.( names{ i } ) ) .* x;
  F{ 3, 4 }.( names{ i } ) =   fun( Fr2.( names{ i } ) ) .* y;
  F{ 4, 2 }.( names{ i } ) = - fun( Fr1.( names{ i } ) ) .* x;
  F{ 4, 3 }.( names{ i } ) = - fun( Fr1.( names{ i } ) ) .* y;
  %  G.12
  F{ 4, 4 }.( names{ i } ) =   fun( F12.( names{ i } ) );
end


function yp = sderiv( y1, y2, eta )
%  SDERIV - Derivative for structure.

%  field names
names = fieldnames( y1 );
%  loop over field names
for i = 1 : numel( names )
  yp.( names{ i } ) = ( y2.( names{ i } ) - y1.( names{ i } ) ) / eta;
end
