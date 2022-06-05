function obj = scale( obj, scale, varargin )
%  SCALE - Scale coordinates of discretized particle surface.
%
%  Usage for obj = particle :
%    obj = scale( obj, scale )
%    obj = scale( obj, scale, varargin )
%  Input
%    obj        :  discretized particle surface
%    scale      :  scaling factor (scalar or vector)
%    varargin   :  additional arguments to be passed to NORM
%  Output
%    obj        :  scaled particle

obj.verts = bsxfun( @times, obj.verts, scale );
if ~isempty( obj.verts2 )
  obj.verts2 = bsxfun( @times, obj.verts2, scale );  
end
%  auxiliary information
obj = norm( obj, varargin{ : } );

