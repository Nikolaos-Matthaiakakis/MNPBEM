function obj = refine( obj )
%  REFINE - Refine particle boundary for face interpolation.
%
% Adopted from function REFINEPATCH by D. Kroon University of Twente.

% vertices of particle
verts = obj.verts;
%  split into triangles
[ faces, ind4 ] = totriangles( particle( obj.verts, obj.faces ) );
%  triangular face elements
ind3 = isnan( obj.faces( :, 4 ) );

%  neighbour vertices of each vertex from the face list
nb = vertex_neighbours( faces( :, 1 ), faces( :, 2 ), faces( :, 3 ),  ...
                        verts( :, 1 ), verts( :, 2 ), verts( :, 3 ) );
%  edge tangents and velocities
[ nvec, vel, ind ] = edge_tangents( verts, nb );
%  B-spline interpolate half way vertices between all existing vertices
[ obj.verts2, index, value ] = make_halfway_vertices( vel, nvec, ind, verts, nb );

%  loop over faces
for i = 1 : size( faces, 1 )
  %  original vertices
  vert1 = faces( i, 1 ); 
  vert2 = faces( i, 2 ); 
  vert3 = faces( i, 3 );
  %  new vertices
  ind = index{ vert1 };  val = value{ vert1 };  verta = val( ind == vert2 );
  ind = index{ vert2 };  val = value{ vert2 };  vertb = val( ind == vert3 );
  ind = index{ vert3 };  val = value{ vert3 };  vertc = val( ind == vert1 );
  %  extend face list
  faces( i, 1 : 3 ) = [ verta( 1 ), vertb( 1 ), vertc( 1 ) ];
end

%  new face list
faces2 = nan( size( obj.faces, 1 ), 9 );
faces2( :, 1 : 4 ) = obj.faces;
%  trianguar elements
if ~isempty( ind3 )
  faces2( ind3, 5 : 7 ) = faces( ind3, 1 : 3 );
end
%  quadrilateral elements
if ~isempty( ind4 )
  %  pointers to triangles
  [ ind4a, ind4b ] = deal( ind4( :, 1 ), ind4( :, 2 ) );
  %  make new face list
  faces2( ind4a, 5 : 9 ) =  ...
      [ faces( ind4a, [ 1, 2 ] ), faces( ind4b, [ 1, 2, 3 ] ) ];
end

%  save new face matrix
obj.faces2 = faces2;
