function obj = init( obj, verts, faces, varargin )
%  INIT - Initialize discretized particle surface.
%
%  Usage for obj = particle :
%    obj = init( obj, verts, faces, op, PropertyPair )
% Input
%    verts    :  vertices of boundary elememts
%    faces    :  faces of boundary elements
%    op        :  option structure to be passed to QUADFACE 
%  PropertyPair
%    'interp'  :  'flat' or 'curv' particle boundaries
%    'norm'    :  'off' for no auxiliary information 

%  return if nothing has to be done
if ~exist( 'verts', 'var' ) || isempty( verts ),  return;  end

%  only triangular elements
if size( faces, 2 ) == 3
  [ obj.verts, obj.faces ] = deal( verts, faces );
  obj.faces( :, 4 ) = NaN; 
%  triangular and/or quadrilateral elements
elseif size( faces, 2 ) == 4
  [ obj.verts, obj.faces ] = deal( verts, faces );
%  intermediate points for curved particle boundary
else
  %  full faces for curved particle interpolation
  [ obj.verts2, obj.faces2 ] = deal( verts, faces );
  %  index to vertices
  faces = reshape( faces( :, 1 : 4 ), [], 1 );
  ind = find( ~isnan( faces ) );
  %  index to unique vertices
  [ ~, ind1, ind2 ] = unique( faces( ind ) );
  %  unique vertices
  obj.verts = verts( faces( ind( ind1 ) ), : );
  %  face list for unique vertices
  faces( ~isnan( faces ) ) = ind2;
  obj.faces = reshape( faces, [], 4 );
end

%  face integration
obj.quad = quadface( varargin{ : } );
%  get options
op = getbemoptions( { 'particle' }, varargin{ : } );
%  flat or curved particle boundary
if isfield( op, 'interp' ),  obj.interp = op.interp;  end
%  auxiliary information for discretized particle surface
if ~isfield( op, 'norm' ) || ~strcmp( op.norm, 'off' )
  obj = norm( obj, varargin{ : } );
end
