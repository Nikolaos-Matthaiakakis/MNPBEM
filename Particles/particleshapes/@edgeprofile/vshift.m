function shift = vshift( obj, z, d )
%  VSHIFT - Displace nodes at edges in vertical direction.
%    Given an edge profile (see e.g. EDGEPROFILE), EDGESHIFT returns the
%    shift value along the z-direction.
%
%  Usage for obj = edgeshift :
%    shift = vshift( obj, z, d )
%  Input
%    z      :  upper or lower edge position
%    d      :  distance of edge point from the polygon contour
%  Output
%    shift  :  shift value 

if isempty( obj.pos ) 
  shift = 0; 
else
  %  make sure that z-value is upper or lower edge
  assert( z == min( obj.pos( :, 2 ) ) || z == max( obj.pos( :, 2 ) ) );
  
  %  upper edge
  if z == max( obj.pos( :, 2 ) )
    if isnan( obj.pos( end, 1 ) )
      shift = 0;
    else
      pos = obj.pos( upper( obj ), : );
      shift = spline( pos( :, 1 ), pos( :, 2 ),  ...
                max( min( pos( :, 1 ) ), - abs( d ) ) ) - max( pos( :, 2 ) );
    end
  %  lower edge
  else
    if isnan( obj.pos( 1, 1 ) )
      shift = 0;
    else  
      pos = obj.pos( lower( obj ), : );
      shift = spline( pos( :, 1 ), pos( :, 2 ),  ...
                max( min( pos( :, 1 ) ), - abs( d ) ) ) - min( pos( :, 2 ) );
    end
  end
end


function ind = upper( obj )
%  UPPER - Indices for upper edge
ind = diff( obj.pos( :, 1 ) ) < 0;  
ind = [ ind; ind( end ) ];
%  find first element where DX changes sign
ind( 1 : find( ind ~= ind( end ), 1, 'last' ) ) = 0;

function ind = lower( obj )
%  LOWER - Indices for lower edge
ind = diff( obj.pos( :, 1 ) ) > 0;
%  find first element where DX changes sign
ind( find( ind ~= ind( 1 ), 1, 'first' ) : end ) = 0;
