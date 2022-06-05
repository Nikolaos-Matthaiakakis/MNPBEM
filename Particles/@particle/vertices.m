function v = vertices( obj, ind, close )
%  VERTICES - Vertices of indexed face.
%
%  Usage for obj = particle :
%    v = verts( obj, vec )
%    v = verts( obj, vec, close )
%  Input
%    ind    :  face index
%    close  :  set keyword 'close' to close the face indices
%  Output
%    v      :  vertices of indexed face

ind = obj.faces( ind, : );
ind = ind( ~isnan( ind ) );

if exist( 'close', 'var' ) && strcmp( close, 'close' )
  ind = [ ind, ind( 1 ) ]; 
end
v = obj.verts( ind, : );