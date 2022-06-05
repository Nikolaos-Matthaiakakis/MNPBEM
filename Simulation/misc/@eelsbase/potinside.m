function [ phi, phip ] = potinside( obj, q, k, mask, medium )
%  POTINSIDE - Potential for electron beam inside of media.
%
%  Usage for obj = eelsbase :
%    [ phi, phip ] = potinside( obj, q, k, gamma, mask, medium )
%  Input
%    q      :  wavenumber of electron beam
%    k      :  wavenumber of light
%    mask   :  compute potential only for selected particle objects
%    medium :  compute potential only for electron beam inside given medium
%  Output
%    phi    :  scalar potential
%    phip   :  surface derivative of scalar potential

%  COMPARTICLE object
p = obj.p;

%  index to face elements
if ~exist( 'mask', 'var' ) || isempty( mask )
  ind1 = 1 : p.n;
else
  ind1 = p.index( mask );
end

%  index to intersection points
if ~exist( 'medium', 'var' ) || isempty( medium )
  ind2 = 1 : size( obj.z, 1 );
else
  ind2 = find( obj.indmat == medium );
end

%%  potential at collocation points
%  allocate arrays
phi  = zeros( p.n, size( obj.z, 1 ) );
phip = zeros( p.n, size( obj.z, 1 ) );

%  collocation points and outer surface normal
[ pos1, nvec ] = deal( p.pos( ind1, : ), p.nvec( ind1, : ) );
%  impact parameters
pos2 = obj.impact( obj.indimp( ind2 ), : );

%  relative coordinates
x = bsxfun( @minus, pos1( :, 1 ), pos2( :, 1 ) .' );
y = bsxfun( @minus, pos1( :, 2 ), pos2( :, 2 ) .' );
z = repmat( pos1( :, 3 ), 1, size( pos2, 1 ) );
%  coordinates perpednicular to electron beam
r  = sqrt( x .^ 2 + y .^ 2 );
rr = sqrt( r .^ 2 + obj.width .^ 2 );

%  multiplication of array and vector
mul = @( x, y ) ( bsxfun( @times, x, y ) );
%  potential
[ I, Ir, Iz ] = potwire( rr, z, q, k, obj.z( ind2, 1 ), obj.z( ind2, 2 ) );
%  assign potential and surface derivative
phi(  ind1, ind2 ) = - 1 / obj.vel * I;
phip( ind1, ind2 ) = - 1 / obj.vel * ( mul( Iz, nvec( :, 3 ) ) +  ...
      Ir .* ( mul( x, nvec( :, 1 ) ) + mul(  y, nvec( :, 2 ) ) ) ./ rr ); 

%%  refined integration over boundary elements
%  boundary elements for refinement
try
  ind1 = reshape( intersect( find( any( obj.indquad, 2 ) ), ind1, 'legacy' ), 1, [] );
catch
  ind1 = reshape( intersect( find( any( obj.indquad, 2 ) ), ind1           ), 1, [] );
end

%  loop over boundary elements
for i1 = ind1
  %  coordinates and weights for refinement
  [ pos1, w ] = quad( p, i1 );
  %  normalize weight
  w = w / p.area( i1 );
  %  outer surface normal
  nvec = p.nvec( i1, : );
          
  %  impact parameters for refinement
  i2 = intersect( find( obj.indquad( i1, obj.indimp ) ), ind2 );
  %  impact parameters
  pos2 = obj.impact( obj.indimp( i2 ), : );  
  
  %  relative coordinates
  x = bsxfun( @minus, pos1( :, 1 ), pos2( :, 1 ) .' );
  y = bsxfun( @minus, pos1( :, 2 ), pos2( :, 2 ) .' );
  z = repmat( pos1( :, 3 ), 1, size( pos2, 1 ) );
  %  coordinates perpednicular to electron beam
  r  = sqrt( x .^ 2 + y .^ 2 );
  rr = sqrt( r .^ 2 + obj.width .^ 2 );
  
  %  potential
  [ I, Ir, Iz ] = potwire( rr, z, q, k, obj.z( i2, 1 ), obj.z( i2, 2 ) );
  %  potential and surface derivative
  phi(  i1, i2 ) = - 1 / obj.vel * w * I;
  phip( i1, i2 ) = - 1 / obj.vel * w * ( Iz .* nvec( 3 ) +  ...
                   Ir .* ( x * nvec( 1 ) + y * nvec( 2 ) ) ./ rr );                  
end  
  