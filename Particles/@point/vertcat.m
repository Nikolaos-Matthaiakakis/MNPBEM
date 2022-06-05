function obj = vertcat( obj, varargin )
%  Concatenate points vertically.
%
%  Usage for obj = point :
%    obj = vertcat( obj1, obj2, obj3, ... )
%    obj = [ obj1; obj2; obj3, ... ]

for i = 1 : length( varargin )
  obj.pos = [ obj.pos;  varargin{ i }.pos ];
  for dim = 1 : 3
    obj.vec{ dim } = [ obj.vec{ dim };  varargin{ i }.vec{ dim } ];
  end
end
