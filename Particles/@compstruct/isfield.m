function is = isfield( obj, name )
% Determines whether compstruct has field with given name.
%
%  Usage for obj = compstruct :
%    is = isfield( obj, name )

is = isfield( obj.val, name );
