function siz = pagesize( obj, vec )
%  PAGESIZE - Paging size of VECARRAY object or user-defined vector array.
%
%  Usage for obj = vecarray :
%    siz = pagesize( obj )
%    siz = pagesize( obj, vec )
%  Input
%    vec  :  vector array

if ~exist( 'val', 'var' ),  vec = obj.vec;  end
%  size of value array
if ismatrix( vec )
  siz = 1;
else
  siz = size( vec );  
  siz = siz( 3 : end );
end
