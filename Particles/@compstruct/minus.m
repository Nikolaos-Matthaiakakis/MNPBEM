function obj1 = minus( obj1, obj2 )
%  Substract fields of two compstruct objects.
%    If the objects have a different number of fields, the missing fields
%    are treated as zero.
%
%  Usage for obj = compstruct :
%    obj = obj1 - obj2

obj1 = plus( obj1, uminus( obj2 ) );