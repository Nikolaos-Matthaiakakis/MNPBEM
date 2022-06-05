function obj = norm( obj, varargin )
%  NORM - Auxiliary information for discretized particle surface.
%    Compute centroids, areas, and basis vectors for surface elements.
%
%  Usage for obj = particle :
%    obj = norm( obj )

%  use routine for flat or curved particle boundary
switch obj.interp
  case 'flat'
    obj = norm_flat( obj );
  case 'curv'
    obj = norm_curv( obj );
end
