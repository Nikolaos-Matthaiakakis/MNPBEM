function varargout = totriangles( obj, varargin )
%  TOTRIANGLES - Split quadrilateral face elements to triangles.
%
%  Usage for obj = particle :
%    [ faces, ind4 ] = totriangles( obj )
%    [ faces, ind4 ] = totriangles( obj, ind )
%  Input
%    ind    :  face index
%  Output
%    faces  :  faces of discretized boundary
%    ind4   :  pointer to split quadrilaterals

%  use routine for flat or curved particle boundary
switch obj.interp
  case 'flat'
    [ varargout{ 1 : nargout } ] = totriangles_flat( obj, varargin{ : } );
  case 'curv'
    [ varargout{ 1 : nargout } ] = totriangles_curv( obj, varargin{ : } );
end
