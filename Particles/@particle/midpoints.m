function obj = midpoints( obj, key )
%  MIDPOINTS - Add mid points for curved particle boundaries.
%
%  Usage for obj = particle :
%    obj = midpoints( obj, key )
%  Input
%    key  :  'flat' or 'curv' for splitting of boundary elements
%  Output
%    obj  :  particle with VERTS2 and FACES2 set

%  default value for KEY
if ~exist( 'key', 'var' ),  key = 'flat';  end
%  set interpolation method
obj.interp = key;

switch key
  %  add midpoints for flat boundary elements
  case 'flat'
    %  edges of particle
    [ net, ind ] = edges( obj );
    %  number of vertices
    n = size( obj.verts, 1 );
    %  add midpoints to vertex list
    obj.verts2 = [ obj.verts;  ...
        0.5 * ( obj.verts( net( :, 1 ), : ) + obj.verts( net( :, 2 ), : ) ) ];
    %  index to triangles and quadrilaterals
    [ ind3, ind4 ] = index34( obj );
    %  allocate array
    obj.faces2 = [ obj.faces, nan( size( obj.faces, 1 ), 5 ) ];
    %  extend face list for triangles
    if ~isempty( ind3 )
      obj.faces2( ind3, [ 5, 6, 7 ] ) = n + ind( ind3, 1 : 3 );
    end
    %  extend face list for quadrilaterals
    if ~isempty( ind4 )
      obj.faces2( ind4, [ 5, 6, 7, 8 ] ) = n + ind( ind4, 1 : 4 ); 
      %  add centroids to face list
      obj.faces2( ind4, 9 ) = size( obj.verts2, 1 ) + ( 1 : numel( ind4 ) );
      %  add centroids to vertex list
      obj.verts2 = [ obj.verts2;  ...
          0.25 * ( obj.verts( obj.faces( ind4, 1 ), : ) +  ...
                   obj.verts( obj.faces( ind4, 2 ), : ) +  ...
                   obj.verts( obj.faces( ind4, 3 ), : ) +  ...
                   obj.verts( obj.faces( ind4, 4 ), : ) ) ];
    end
      
  %  add midpoints using the approximate curvature   
  case 'curv'   
    obj = refine( obj );
end

%  auxiliary information for discretized particle surface
if strcmp( obj.interp, 'curv' ),  obj = norm( obj );  end
