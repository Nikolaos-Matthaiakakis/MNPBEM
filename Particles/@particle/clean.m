function obj = clean( obj, cutoff )
%  CLEAN - Remove multiple vertices and elements with too small areas.
%
%  Usage for obj = particle :
%    obj = clean( obj, cutoff )
%  Input
%    cutoff :  keep only surface elements with
%                area > cutoff * mean( area ) (cutoff = 1e-10 on default)
%  Output
%    obj    :  particle with small surface elements removed

if ~exist( 'cutoff', 'var' );  cutoff = 1e-10;  end

%  avoid rounding errors
verts = misc.round( obj.verts, 8 );
%  unique vertices
[ verts, ~, ind ] = unique( verts, 'rows' ); 
%  remove multiple vertices
if size( verts, 1 ) ~= size( obj.verts, 1 )
  faces = obj.faces;
  %  index to triangular and quadrilateral boundary elements
  [ ind3, ind4 ] = index34( obj );
  %  update triangular and quadrilateral boundary elements
  faces( ind3, 1 : 3 ) = ind( faces( ind3, 1 : 3 ) );
  faces( ind4, 1 : 4 ) = ind( faces( ind4, 1 : 4 ) );
  %  update object
  [ obj.verts, obj.faces ] = deal( verts, faces );
end

%  remove quadrilaterals with double vertices
for i = transpose( find( ~isnan( obj.faces( :, 4 ) ) ) )
  %  unique elements of faces
  [ ~, order ] = unique( obj.faces( i, : ) );
  %  remove elements with duplicate vertices
  if numel( order ) == 3
    obj.faces( i, : ) = [ obj.faces( i, sort( order ) ), NaN ];
  end
end

%  keep only elements with sufficiently large areas
obj = norm( select( obj, 'ind',  ...
                   find( obj.area > cutoff * mean( obj.area ) ) ) );
