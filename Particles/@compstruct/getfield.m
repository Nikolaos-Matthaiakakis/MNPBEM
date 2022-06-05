function field = getfield( obj, name )
%  GETFIELD - Get the value of a compstruct field.
%
%  Usage for obj = compstruct :
%    field = getfield( obj, name )

field = getfield( obj.val, name );
