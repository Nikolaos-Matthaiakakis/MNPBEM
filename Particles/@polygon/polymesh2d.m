function [ verts, faces ] = polymesh2d( obj, varargin )
%  Call mesh2d functions with polygons.
%
%  Usage for obj = polygon :
%    [ verts, faces ] = polymesh2d( obj, 'PropertyName', PropertyValue, ...)
%  PropertyName
%    hdata      :  pass hdata to mesh2d
%    options    :  pass options structure to mesh2d
%  Output
%    verts      :  vertices of 2D traingulation of mesh2d
%    faces      :  faces of 2D triangulation of mesh2d

%  extract input
for i = 1 : 2 : length( varargin )
  switch varargin{ i }
    case 'hdata'
      hdata = varargin{ i + 1 };
    case { 'options', 'op' }
      options = varargin{ i + 1 };
  end
end

if ~exist( 'options', 'var' ); options = struct( 'output', false );  end
if ~exist( 'hdata',   'var' ); hdata = [];                           end

%  put all polygons together and make triangulation
[ pos, cnet ] = union( obj );

warning off MATLAB:delaunayn:DuplicateDataPoints
warning off MATLAB:tsearch:DeprecatedFunction
[ verts, faces ] = mesh2d( pos, cnet, hdata, options );
