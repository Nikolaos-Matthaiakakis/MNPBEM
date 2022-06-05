function net = border( obj )
%  BORDER - Find border (single edges) of particle.
%
%  Usage for obj = particle :
%    net = border( obj )
%  Output
%    net    :  edge list

%  faces
faces = obj.faces;
%  index to triangular and quadrilateral boundary elements
[ ind3, ind4 ] = index34( obj );

%  edge list
net = [ faces( ind3, [ 1, 2 ] ); faces( ind3, [ 2, 3 ] );  ...
        faces( ind3, [ 3, 1 ] );                           ...
        faces( ind4, [ 1, 2 ] ); faces( ind4, [ 2, 3 ] );  ...
        faces( ind4, [ 3, 4 ] ); faces( ind4, [ 4, 1 ] ) ];     
%  unique edges
[ ~, ind, inde ] = unique( sort( net, 2 ), 'rows' );
%  determine single edges
[ h, indh ] = hist( inde, 1 : numel( ind ) );
net = net( ind( indh( h == 1 ) ), : );
