function obj = shift( obj, vec, varargin )
%  SHIFT - Shift discretized particle surface.
%
%  Usage for obj = particle :
%    obj = shift( obj, vec )
%    obj = shift( obj, vec, varargin )
%  Input
%    obj        :  discretized particle surface
%    vec        :  vector for particle shift
%    varargin   :  additional arguments to be passed to NORM
%  Output
%    obj        :  shifted particle surface

obj.verts = bsxfun( @plus, obj.verts, vec );
if ~isempty( obj.verts2 )
  obj.verts2 = bsxfun( @plus, obj.verts2, vec );  
end
%  auxiliary information for discretized particle boundary
obj = norm( obj, varargin{ : } );
