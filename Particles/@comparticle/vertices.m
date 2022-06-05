function v = vertices( obj, ind, varargin )
%  VERTICES - Vertices of indexed face.
%
%  Usage for obj = comparticle :
%    v = verts( obj, vec )
%    v = verts( obj, vec, close )
%  Input
%    ind    :  face index
%    close  :  set keyword 'close' to close the face indices
%  Output
%    v      :  vertices of indexed face

%  particle and face index
[ ip, ind ] = ipart( obj, ind );
%  vertices
v = vertices( obj.p{ ip }, ind, varargin{ : } );
