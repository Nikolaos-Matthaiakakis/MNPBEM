function [ pos, w ] = adapt( obj, varargin )
%  ADAPTRULE - Adapt stored integration points to boundary element.

%  extract input
if ~isnumeric( varargin{ 1 } )
  verts = vertices( varargin{ : } );
elseif nargin == 1
  verts = varargin{ 1 };
else
  verts = vertcat( varargin{ : } );
end

%  points and weights for triangle integration
if size( verts, 1 ) == 3
  [ pos, w ] = adaptrule( obj, verts, [ 1, 2, 3 ] );
else
  %  divide quadrilateral into two triangles
  [ posa, wa ] = adaptrule( obj, verts, [ 1, 2, 3 ] );
  [ posb, wb ] = adaptrule( obj, verts, [ 3, 4, 1 ] );
  %  put together integration points and weights
  pos = [ posa; posb ];  w = [ wa, wb ];
end
