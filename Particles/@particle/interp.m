function [ v, mat ] = interp( obj, v, key )
%  INTERP - Interpolate value from faces to vertices (or vice versa).
%
%  Usage for obj = particle :
%    [ vi, mat ] = interp( obj, v, key )
%  Input
%    v      :  array or structure with values given at faces/vertices 
%    key    :  interpolation method 'area' (default) or 'pinv'
%  Output
%    vi     :  values at vertices/faces 
%    mat    :  interpolation matrix

if ~exist( 'key', 'var' ),  key = 'area';  end

%  index to triangles and quadrilaterals
[ ind3, ind4 ] = index34( obj );
%  number of faces and vertices
[ nfaces, nverts ] = deal( size( obj.faces, 1 ), size( obj.verts, 1 ) );
%  face elements for triangles and quadrilaterals
faces3 = obj.faces( ind3, 1 : 3 );  ind3 = repmat( ind3, 1, 3 );
faces4 = obj.faces( ind4, 1 : 4 );  ind4 = repmat( ind4, 1, 4 );

%  leading order of V
if isnumeric( v )
  n = size( v, 1 );
else
  names = fieldnames( v );
  n = size( v.( names{ 1 } ), 1 );
end

%%  interpolation matrix
if n == nfaces
  %  interpolate from faces to vertices
  switch key
    case 'area'
      %  average at vertices weighted by areas of boundary elements
      mat = sparse( faces3, ind3, obj.area( ind3 ), nverts, nfaces ) + ...
            sparse( faces4, ind4, obj.area( ind4 ), nverts, nfaces );
      %  normalize transformation matrix
      mat = spdiag( 1 ./ sum( mat, 2 ) ) * mat;
    case 'pinv'
      %  connectivity matrix
      con = sparse( ind3, faces3, 1/3, nfaces, nverts ) +  ...
            sparse( ind4, faces4, 1/4, nfaces, nverts ); 
      %  pseudo-inverse of connectivity matrix
      mat = pinv( full( con ) );
  end
else 
  %  interpolate from vertices to faces
  mat = sparse( ind3, faces3, 1/3, nfaces, nverts ) +  ...
        sparse( ind4, faces4, 1/4, nfaces, nverts ); 
end

%%  interpolate to vertices
if exist( 'v', 'var' ) && ~isempty( v )
  if isnumeric( v )
    v = matmul( mat, v );
  else
    for i = 1 : length( names )
      v.( names{ i } ) = matmul( mat, v.( names{ i } ) );
    end    
  end
else
  v = [];
end
