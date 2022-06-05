function [ obj1, obj2 ] = select( obj, varargin )
%  SELECT - Select parts of discretized particle surface.
%
%  Usage for obj = particle :
%    [ obj1, obj2 ] = select( obj, 'PropertyName', PropertyValue )
%  PropertyName
%    'index'    :  index to selected elements
%    'carfun'   :  function f( x, y, z ) for selected elements
%    'polfun'   :  function f( phi, r, z ) for selected elements
%    'sphfun'   :  function f( phi, theta, r ) for selected elements
%  Output
%    obj1       :  particle surface with selected elements
%    obj2       :  complement of selected particle surface

x  = obj.pos( :, 1 );
y  = obj.pos( :, 2 );
z  = obj.pos( :, 3 );

%  select faces
switch varargin{ 1 }
  case { 'ind', 'index' }
    index = varargin{ 2 };
  case { 'carfun', 'cartfun' }
    index = find( feval( varargin{ 2 }, x, y, z ) );
  case 'polfun'
    [ phi, r, z ] = cart2pol( x, y, z );
    index = find( feval( varargin{ 2 }, phi, r, z ) );
  case 'sphfun'
    [ phi, theta, r ] = cart2sph( x, y, z );
    index = find( feval( varargin{ 2 }, phi, pi / 2 - theta, r ) );
  otherwise
    error( 'input not known' );
end

%  particle with selected faces
obj1 = compress( obj, index );
%  complement of selected particle
if nargout == 2
  index = setdiff( 1 : size( obj.faces, 1 ), index );
  obj2 = compress( obj, index );
end


function obj = compress( obj, index )
%  COMPRESS - Compress particle and remove unused vertices.

faces = obj.faces( index, : );
%  find unique vertices
ind = unique( faces( : ) );
ind = ind( ~isnan( ind ) );
%  make table of unique vertices
table( ind ) = 1 : length( ind );
faces( ~isnan( faces ) ) = table( faces( ~isnan( faces ) ) );
%  new vertices and faces of particle
[ obj.verts, obj.faces ] = deal( obj.verts( ind, : ), faces );

if ~isempty( obj.verts2 )
  faces2 = obj.faces2( index, : );
  %  find unique vertices 
  ind = unique( faces2( : ) );
  ind = ind( ~isnan( ind ) );
  %  make table of unique vertices
  table( ind ) = 1 : length( ind );
  faces2( ~isnan( faces2 ) ) = table( faces2( ~isnan( faces2 ) ) );
  %  new vertices and faces of particle
  [ obj.verts2, obj.faces2 ] = deal( obj.verts2( ind, : ), faces2 );    
end

%  auxiliary information
obj = norm( obj );
