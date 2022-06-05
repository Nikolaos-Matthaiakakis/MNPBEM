function is = ispage( obj )
%  ISPAGE - True if value array is a multi-dimensional array.
%
%  Usage for obj = valarray :
%    is = ispage( obj )
%  Output
%    is     :  true if OBJ is a multi-dimensional array, and false otherwise

if obj.truecolor
  is = false;
else
  is = ( size( obj.val, 2 ) ~= 1 | ndims( obj.val ) > 2 );
end
