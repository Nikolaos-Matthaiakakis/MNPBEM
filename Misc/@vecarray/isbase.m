function is = isbase( obj, pos )
%  ISBASE - Checks for equality of vector positions.
%
%  Usage for obj = vecarray :
%    is = isbase( obj, pos )
%  Input
%    pos    :  vector positions
%  Output
%    is     :  true if vector positions of OBJ are same as POS, and false otherwise

if isnumeric( pos ) &&  ...
    size( pos, 1 ) == size( obj.pos, 1 ) && all( pos( : ) == obj.pos( : ) )
  is = true;
else
  is = false;
end
  