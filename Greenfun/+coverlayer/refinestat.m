function [ g, f ] = refinestat( obj, g, f, p, ind )
%  REFINESTAT - Refine quasistatic Green function object.
%    Green function elements for neighbour cover layer elements are refined
%    through polar integration.
% 
%  Usage for obj = greenstat : 
%    obj = coverlayer.refinestat( obj, g, f, p, ind )
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
%  measure positions with respect to centroids
x = p.pos( ind1, 1 ) - pos( :, 1 );
y = p.pos( ind1, 2 ) - pos( :, 2 );
z = p.pos( ind1, 3 ) - pos( :, 3 );
%  distance
r = sqrt( x .^ 2 + y .^ 2 + z .^ 2 );

%  Green function elements
g( ind ) = accumarray( ind2, weight ./ r );
%  derivative of Green function
fx = - accumarray( ind2, weight .* x ./ r .^ 3 );
fy = - accumarray( ind2, weight .* y ./ r .^ 3 );
fz = - accumarray( ind2, weight .* z ./ r .^ 3 );
%  save surface derivative
if strcmp( obj.deriv, 'cart' )
  f( ind, : ) = [ fx, fy, fz ];
else
  f( ind ) = fx .* p.nvec( i1, 1 ) +  ...
             fx .* p.nvec( i1, 2 ) +  ...
             fz .* p.nvec( i1, 3 );
end
