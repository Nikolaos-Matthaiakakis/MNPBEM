function [ obj, ipos ] = interp1( obj, pos )
%  Make new polygon through given positions using interpolation.
%
%  Usage for obj = polygon :
%    [ obj, ipos ] = interp1( obj, pos )
%  Input
%    obj    :  single object or array
%    pos    :  positions that lie on the polygon obj
%  Output
%    obj    :  new polygon passing through pos
%    ipos   :  order of positions in new polygon

if length( obj ) ~= 1
  for i = 1 : length( obj )
    [ obj( i ), ipos{ i } ] = interp1( obj( i ), pos ); 
  end
  return
end

%  find points on polygon
ipos = 1 : size( pos, 1 );

[ d, inst ] = dist( obj, pos );

ipos = ipos( abs( d ) < 1e-6 );
inst = inst( abs( d ) < 1e-6 );

%  distance to nearest neighbour
dist2 = @( a, b ) ( sqrt( ( a( :, 1 ) - b( :, 1 ) ) .^ 2 +  ...
                          ( a( :, 2 ) - b( :, 2 ) ) .^ 2 ) );
d = dist2( obj.pos( inst, : ), pos( ipos, : ) );

%  sort according to distance
[ ~, ind ] = sort( d );

ipos = ipos( ind );
inst = inst( ind );

%  sort according to index of nearest neighbour
[ ~, ind ] = sort( inst );

ipos = ipos( ind );

%  interpolated polygon
obj.pos = pos( ipos, : );
