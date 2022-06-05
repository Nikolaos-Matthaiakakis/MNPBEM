function [ phi, a, phip, ap ] = unpack( obj, vec )
%  UNPACK - Unpack scalar and vector potentials from vector.

%  last dimension
siz = numel( vec ) / ( 8 * obj.p.n );
%  reshape vector
vec = reshape( vec, [], 8 );
%  extract potentials from vector
phi  = reshape( vec( :, 1     ), [],    siz );
a    = reshape( vec( :, 2 : 4 ), [], 3, siz );
phip = reshape( vec( :, 5     ), [],    siz );
ap   = reshape( vec( :, 6 : 8 ), [], 3, siz );
