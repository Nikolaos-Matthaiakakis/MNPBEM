function obj = flipfaces( obj, varargin )
%  FLIPFACES - Flip orientation of surface elements.
%
%  Usage for obj = particle :
%    obj = flipfaces( obj )
%    obj = flipfaces( obj, varargin )
%  Input
%    varargin   :  additional arguments to be passed to NORM
%  Output
%    obj        :  flipped particle faces

%  index to triangular and quadrilateral face elements
[ ind3, ind4 ] = index34( obj );
%  flip faces
obj.faces( ind3, 1 : 3 ) = fliplr( obj.faces( ind3, 1 : 3 ) );
obj.faces( ind4, 1 : 4 ) = fliplr( obj.faces( ind4, 1 : 4 ) );

if ~isempty( obj.verts2 )
  obj.faces2( ind3, [ 1, 2, 3, 5, 6, 7 ] ) =  ...
  obj.faces2( ind3, [ 3, 2, 1, 6, 5, 7 ] );
  obj.faces2( ind4, [ 1, 2, 3, 4, 5, 6, 7, 8 ] ) =  ...
  obj.faces2( ind4, [ 4, 3, 2, 1, 7, 6, 5, 8 ] );
end

%  auxiliary information
obj = norm( obj, varargin{ : } );