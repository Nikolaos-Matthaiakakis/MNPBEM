function [ phi, phip ] = potinfty( obj, q, gamma, mask, medium )
%  POTINFTY - Potential for infinite electron beam in medium.
%
%  Usage for obj = eelsbase :
%    [ phi, phip ] = potinfty( obj, q, gamma, mask )
%  Input
%    q      :  wavenumber
%    gamma  :  Lorentz contraction factor
%    mask   :  compute potential only for selected particle objects
%  Output
%    phi    :  scalar potential
%    phip   :  surface derivative of scalar potential

%  COMPARTICLE object
p = obj.p;

%  Lorentz contraction factor
if ~exist( 'gamma', 'var' ) || isempty( gamma )
    gamma = 1;
end

%  index to face elements
if ~exist( 'mask', 'var' ) || isempty( mask )
  ind1 = 1 : p.n;
else
  ind1 = p.index( mask );
end

%  index to intersection points
if ~exist( 'medium', 'var' ) || isempty( medium )
  ind2 = 1 : size( obj.impact, 1 );
else
  ind2 = obj.indimp( obj.indmat == medium );
end

%%  potential at collocation points
%  collocation points and outer surface normal
[ pos1, nvec ] = deal( p.pos( ind1, : ), p.nvec( ind1, : ) );
%  impact parameters
pos2 = obj.impact( ind2, : );

%  relative coordinates
x = bsxfun( @minus, pos1( :, 1 ), pos2( :, 1 ) .' );
y = bsxfun( @minus, pos1( :, 2 ), pos2( :, 2 ) .' );
z = repmat( pos1( :, 3 ), 1, size( pos2, 1 ) );
%  normal coordinate 
r  = sqrt( x .^ 2 + y .^ 2 );
rr = sqrt( r .^ 2 + obj.width .^ 2 );

%  allocate arrays
phi  = zeros( p.n, size( obj.impact, 1 ) );
phip = zeros( p.n, size( obj.impact, 1 ) );
%  multiplication of array and vector
mul = @( x, y ) ( bsxfun( @times, x, y ) );
%  Bessel functions
K0 = besselk( 0, q * rr / gamma );
K1 = besselk( 1, q * rr / gamma );
%  potential and surface derivative
phi(  ind1, ind2 ) = - 2 / obj.vel * exp( 1i * q * z ) .* K0;
phip( ind1, ind2 ) = - 2 / obj.vel * exp( 1i * q * z ) * q .*  ...
       ( 1i * mul( K0, nvec( :, 3 ) ) - K1 / gamma .*          ...
            ( mul( x,  nvec( :, 1 ) ) + mul( y, nvec( :, 2 ) ) ) ./ rr );

%%  refined integration over boundary elements
%  boundary elements for refinement
ind1 = reshape( intersect( find( any( obj.indquad, 2 ) ), ind1 ), 1, [] );

%  loop over boundary elements
for i1 = ind1
  %  coordinates and weights for refinement
  [ pos1, w ] = quad( p, i1 );
  %  normalize weight
  w = w / p.area( i1 );
  %  outer surface normal
  nvec = p.nvec( i1, : );
  
  %  corresponding impact parameters
  i2 = find( obj.indquad( i1, : ) );
  %  impact parameters
  pos2 = obj.impact( i2, : );  
  
  %  relative coordinates
  x = bsxfun( @minus, pos1( :, 1 ), pos2( :, 1 ) .' );
  y = bsxfun( @minus, pos1( :, 2 ), pos2( :, 2 ) .' );
  z = repmat( pos1( :, 3 ), 1, size( pos2, 1 ) );  
  %  normal coordinate 
  r  = sqrt( x .^ 2 + y .^ 2 );
  rr = sqrt( r .^ 2 + obj.width .^ 2 );

  %  Bessel functions
  K0 = besselk( 0, q * rr / gamma );
  K1 = besselk( 1, q * rr / gamma );
  %  potential and surface derivative
  phi(  i1, i2 ) = - 2 / obj.vel * w * ( exp( 1i * q * z ) .* K0 );
  phip( i1, i2 ) = - 2 / obj.vel * w * ( exp( 1i * q * z ) * q .* ...
    ( 1i * K0 * nvec( 3 )  -                                      ...
           K1 / gamma .* ( x * nvec( 1 ) + y * nvec( 2 ) ) ./ rr ) );  
end
