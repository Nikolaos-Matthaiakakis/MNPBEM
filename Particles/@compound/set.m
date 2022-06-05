function obj = set( obj, varargin )
%  SET - Set properties of compound.

for i = 1 : 2 : numel( varargin )
  obj.pc.( varargin{ i } ) = varargin{ i + 1 };
end
