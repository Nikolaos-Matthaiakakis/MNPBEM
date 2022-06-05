function obj = mtimes( val, obj )
%  Multiply fields of compstruct with given value
%
%  Usage for obj = compstruct :
%    obj = val * obj

if ~isa( obj, 'compstruct' )
  [ obj, val ] = deal( val, obj );
end

%  get field names
names = fieldnames( obj.val );

for i = 1 : length( names )
  obj.val = setfield( obj.val, names{ i },  ...
                      val * getfield( obj.val, names{ i } ) );
end
