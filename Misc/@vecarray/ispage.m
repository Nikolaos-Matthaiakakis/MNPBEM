function is = ispage( obj )
%  ISPAGE - True if vector array is a multi-dimensional array.
%
%  Usage for obj = vecarray :
%    is = ispage( obj )
%  Output
%    is     :  true if OBJ is a multi-dimensional array, and false otherwise

is = ~ismatrix( obj.vec );
