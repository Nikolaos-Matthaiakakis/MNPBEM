function obj = vertcat( obj, varargin )
%  Concatenate particles vertically.
%
%  Usage for obj = particle :
%    obj = vertcat( obj1, obj2, obj3, ... )
%    obj = [ obj1; obj2; obj3; ... ]
%  Output
%    obj        :  combined particle surface

for i = 1 : length( varargin )
  %  extend face-vertex list
  obj.faces  = [ obj.faces;  varargin{ i }.faces + size( obj.verts, 1 ) ];  
  obj.verts  = [ obj.verts;  varargin{ i }.verts ];
  %  extend face-vertex list for curved particle boundary
  if ~isempty( obj.verts2 )
    obj.faces2  = [ obj.faces2;  varargin{ i }.faces2 + size( obj.verts2, 1 ) ];  
    obj.verts2  = [ obj.verts2;  varargin{ i }.verts2 ];
  end
end

%  auxiliary information about particle
obj = norm( obj );
