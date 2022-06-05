function names = fieldnames( obj )
%  Get field names of compstruct.
%
%  Usage for obj = compstruct :
%    names = fieldnames( obj )

names = fieldnames( obj.val );
