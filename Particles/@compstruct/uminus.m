function obj = uminus( obj )
%  Negate fields of compstruct object.
%
%  Usage for obj = compstruct :
%    obj = - obj

%  get field names
names = fieldnames( obj.val );

for i = 1 : length( names )
  obj.val = setfield( obj.val, names{ i },  ...
                             - getfield( obj.val, names{ i } ) );
end
