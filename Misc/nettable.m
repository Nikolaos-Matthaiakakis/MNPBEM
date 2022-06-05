function [ net, inet ] = nettable( faces )
%  NETTABLE - Table of connections between vertices.
%
%  Usage :
%    [ net, inet ] = nettable( faces )
%  Input
%    faces  :  faces of particle boundary
%  Output
%    net    :  list of connections
%    inet   :  face-to-net index

%  triangular faces
i3 = reshape( find( isnan( faces( :, 4 ) ) ), [], 1 );
if ~isempty( i3 )
  %  connections between vertices
  net = [ faces( i3, 1 ), faces( i3, 2 );  ...
          faces( i3, 2 ), faces( i3, 3 );  ...
          faces( i3, 3 ), faces( i3, 1 ) ];
  %  pointer to corresponding faces
  inet = repmat( i3, 3, 1 );  
else
  net = [];  inet = [];
end
%  quadrilateral faces
i4 = reshape( find( ~isnan( faces( :, 4 ) ) ), [], 1 );
if ~isempty( i4 )
  %  connections between vertices
  net = [ net;  faces( i4, 1 ), faces( i4, 2 );  ...
                faces( i4, 2 ), faces( i4, 3 );  ...
                faces( i4, 3 ), faces( i4, 4 );  ...
                faces( i4, 4 ), faces( i4, 1 ) ];
  %  pointer to corresponding faces
  inet = [ inet;  repmat( i4, 4, 1 ) ];  
end
