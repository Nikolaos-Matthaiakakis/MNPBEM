function curv = curvature( obj, varargin )
%  CURVATURE - Curvature of discretized particle.
%
%  Usage for obj = particle :
%    curv = curvature( obj, varargin )
%  Output
%    curv   :  structure with curvature information (see PATCHCURVATURE)

%  index to triangles and quadrilaterals
[ ind3, ind4 ] = index34( obj );

faces = obj.faces( ind3, 1 : 3 );
%  split quadrilateral faces
if ~isempty( ind4 );
  faces = [ faces; obj.faces( ind4, [ 1, 2, 3 ] ); obj.faces( ind4, [ 3, 4, 1 ] ) ];
end

s = warning( 'off', 'MNPBEM:zeroArea' );
%  remove multiple faces with too small areas
obj = clean( particle( obj.verts, faces ) );
%  restore warning
warning( s );

%  curvature information
[ curv.mean, curv.gauss, curv.dir1, curv.dir2, curv.lambda1, curv.lambda2 ] =  ...
  patchcurvature( struct( 'faces', obj.faces( :, 1 : 3 ), 'vertices', obj.verts ), varargin{ : } );
