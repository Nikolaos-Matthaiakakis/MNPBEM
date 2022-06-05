function rad = enclosure( p )
%  ENCLOSURE - Maximal radius between centroids and boundary vertices.
%  
%  Usage :
%    rad = enclosure( p )
%  Input
%    p          :  particle object
%  Output
%    rad        :  maximal radius between centroids and boundary vertices.

%  allocate arrays
x = zeros( p.n, 4 );
y = zeros( p.n, 4 );

%  triangles
ind = isnan( p.faces( :, 4 ) );
%  coordinate difference
x( ind, 1 : 3 ) = repmat( p.pos( ind, 1 ), [ 1, 3 ] ) -  ...
                  reshape( p.verts( p.faces( ind, 1 : 3 ), 1 ), [], 3 );
y( ind, 1 : 3 ) = repmat( p.pos( ind, 2 ), [ 1, 3 ] ) -  ...
                  reshape( p.verts( p.faces( ind, 1 : 3 ), 2 ), [], 3 );

%  quadrilaterals
ind = ~isnan( p.faces( :, 4 ) );
%  coordinate difference
x( ind, 1 : 4 ) = repmat( p.pos( ind, 1 ), [ 1, 4 ] ) -  ...
                  reshape( p.verts( p.faces( ind, 1 : 4 ), 1 ), [], 4 );
y( ind, 1 : 4 ) = repmat( p.pos( ind, 2 ), [ 1, 4 ] ) -  ...
                  reshape( p.verts( p.faces( ind, 1 : 4 ), 2 ), [], 4 );

%  radius
rad = sqrt( x .^ 2 + y .^ 2 );
%  maximal radius
rad = max( rad( : ) );
