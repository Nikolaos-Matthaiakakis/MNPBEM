function [ g, f ] = refineret( obj, g, f, p, ind )
%  REFINERET - Refine retarded Green function object.
%    Green function elements for neighbour cover layer elements are refined
%    through polar integration.
% 
%  Usage for obj = greenret : 
%    obj = coverlayer.refineret( obj, g, f, p, ind )
%  Input
%    g, f     :  Green function element for additional refinement
%    p        :  COMPARTICLE object
%    ind      :  particle indices for refinement
%  Output
%    obj      :  refined Green function object

%  index to Green function elements for refinement
i1 = index( p, ind( :, 1 ) .' );
i2 = index( p, ind( :, 2 ) .' );
%  particle index
[ ~, ind ] = ismember( sub2ind( [ p.n, p.n ], i1, i2 ), obj.ind );
[ i1, i2, ind ] = deal( i1( ind ~= 0 ), i2( ind ~= 0 ), ind( ind ~= 0 ) );

%  integration points and weights
[ pos, weight, ind2 ] = quadpol( p, i2 );
ind1 = reshape( i1( ind2 ), [], 1 );
%  difference vector between face centroid and integration points 
x = p.pos( ind1, 1 ) - pos( :, 1 );
y = p.pos( ind1, 2 ) - pos( :, 2 );
z = p.pos( ind1, 3 ) - pos( :, 3 );
%  distance
r = sqrt( x .^ 2 + y .^ 2 + z .^ 2 );

%  difference vector between face centroids
vec0 = - ( p.pos( ind1, : ) - p.pos( i2( ind2 ), : ) );
%  distance
r0 = sqrt( dot( vec0, vec0, 2 ) );

%  integration function
quad = @( f ) accumarray( ind2, weight .* f );
%  Green function
for ord = 0 : obj.order
  g( ind, ord + 1 ) = quad( ( r - r0 ) .^ ord ./ ( r * factorial( ord ) ) );
end

%  surface derivative of Green function
switch obj.deriv
  case 'norm'
    %  inner product
    in = x .* p.nvec( ind1, 1 ) + y .* p.nvec( ind1, 2 ) + z .* p.nvec( ind1, 3 );
    %  lowest order
    f( ind, 1 ) = - quad( in ./ r .^ 3 );
    %  loop over orders
    for ord = 1 : obj.order
      f( ind, ord + 1 ) = quad(  ...
        in .* ( ( r - r0 ) .^   ord       ./ ( r .^ 3 * factorial( ord     ) ) +  ...
                ( r - r0 ) .^ ( ord - 1 ) ./ ( r .^ 2 * factorial( ord - 1 ) ) ) ); 
    end
  case 'cart'
    %  vector integration function
    fun = @( f ) [ quad( x .* f ), quad( y .* f ), quad( z .* f ) ];
    %  lowest order
    f( ind, :, 1 ) = - fun( 1 ./ r .^ 3 );
    %  loop over orders
    for ord = 1 : obj.order
      f( ind, :, ord + 1 ) = fun(                                           ...
        - ( r - r0 ) .^   ord       ./ ( r .^ 3 * factorial( ord     ) ) +  ...
          ( r - r0 ) .^ ( ord - 1 ) ./ ( r .^ 2 * factorial( ord - 1 ) ) );
    end    
end
