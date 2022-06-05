function siz = matsize( obj1, obj2 )
%  MATSIZE - Size for cluster tree matrix.
%
%  Usage for obj = clustertree :
%    siz = matsize( obj1, obj2 )
%  Output
%    siz      :  matrix size

siz = [ size( obj1.ind, 1 ), size( obj2.ind, 1 ) ];