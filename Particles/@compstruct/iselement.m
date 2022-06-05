function is = iselement( obj, name )
%  Determine whether compstruct has a field with a given name.
%
%  Usage for obj = compstruct :
%    is = iselement( obj, name )

names = fieldnames( obj.val );
is = any( strcmp( name, names ) );
