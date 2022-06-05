function obj = curved( obj, varargin )
%  CURVED - Make curved particle boundary.
%
%  Usage for obj = particle :
%    obj = curved( obj, varargin )
%  Input
%    varargin   :  additional arguments to be passed to MIDPOINTS

%  curved particle boundaries
if isempty( obj.verts2 ) || ~isempty( varargin )
  obj = midpoints( obj, varargin{ : } );
end

%  set curved flag
obj.interp = 'curv';
%  auxiliary information for discretized particle surface
obj = norm( obj );
