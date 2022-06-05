function obj = set( obj, varargin )
%  SET - Set field names of compstruct object.
%
%  Usage for obj = compstruct :
%    obj = set( obj, 'FieldName', FieldValue, ... )

for i = 1 : 2 : length( varargin )
  obj.val.( varargin{ i } ) = varargin{ i + 1 };
end
