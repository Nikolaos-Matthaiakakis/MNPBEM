classdef particle
  %  Faces and vertices of discretized particle.
  %  The particle faces can be either triangles or quadrilaterals, or both.
  
%%  Properties
  properties
    verts        %  vertices
    faces        %  triangle or quadrilateral faces
    pos          %  centroids of faces
    vec          %  tangential and normal vectors at centroids
    area         %  area of faces
    quad         %  quadrature rules for boundary element integration
  end
  
  properties
    verts2 = []         %  additional vertices for curved particle boundary
    faces2 = []         %  additional faces for curved particle boundary
    interp = 'flat'     %  'flat' or 'curv' particle boundaries
  end

%%  Methods
  methods
    function obj = particle( varargin )
      %  Set vertices and faces of discretized particle surface.
      %
      %  Usage :
      %    obj = particle( verts, faces, op, PropertyPair )
      % Input
      %    verts     :  vertices of boundary elememts
      %    faces     :  faces of boundary elements
      %    op        :  option structure to be passed to QUADFACE 
      %  PropertyPair
      %    'interp'  :  'flat' or 'curv' particle boundaries
      %    'norm'    :  'off' for no auxiliary information 
      obj = init( obj, varargin{ : } );
    end
    
    function disp( obj )
      %  Command window display.
      disp( 'particle : ' );
      disp( struct( 'verts', obj.verts, 'faces', obj.faces,  ...
                                       'interp', obj.interp ) );
    end     
  end
  
end
