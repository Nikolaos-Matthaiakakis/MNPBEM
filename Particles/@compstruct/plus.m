function obj1 = plus( obj1, obj2 )
%  Add fields of two compstruct objects.
%    If the objects have a different number of fields, the missing fields
%    are treated as zero.
%
%  Usage for obj = compstruct :
%    obj = obj1 + obj2

%  get field names
names = fieldnames( obj2.val );

for i = 1 : length( names )
  if isfield( obj1.val, names{ i } )
    obj1.val = setfield( obj1.val, names{ i },                      ...
                                getfield( obj1.val, names{ i } ) +  ...
                                getfield( obj2.val, names{ i } ) );
  else
    obj1.val = setfield( obj1.val, names{ i },                      ...
                                getfield( obj2.val, names{ i } ) );
  end
end
