function shift = hshift( obj, z )
%  HSHIFT - Displace nodes at edges in horizontal direction.
%    Given an edge profile (see e.g. EDGEPROFILE), EDGESHIFT returns the
%    shift value along the normal direction of the polygon.
%
%  Usage for obj = edgeprofile :
%    shift = hshift( obj, z )
%  Input
%    z      :  z-value of the edge point 
%  Output
%    shift  :  shift value along horizontal direction

if isempty( obj.pos )
  shift = z;  return
end

%  z-value in proper range ?
assert( all( z >= min( obj.pos( :, 2 ) ) & z <= max( obj.pos( :, 2 ) ) ) );

ind = ~isnan( obj.pos( :, 1 ) ) & ~isnan( obj.pos( :, 2 ) );
%  displace along x direction
shift = spline( obj.pos( ind, 2 ), obj.pos( ind, 1 ), z );
