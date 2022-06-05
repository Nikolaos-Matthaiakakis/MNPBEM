function [ z1, z2 ] = adjust( obj, z1, z2, op )
%  ADJUST - Adjust z-value limits.
%
%  Usage for obj = layerstructure :
%    [ z1, z2 ] = adjust( obj, z1, z2, op )
%  Input
%    z1     :  range for z1
%    z2     :  range for z2
%    op     :  option structure with
%               'scale'  -  scale factor for automatic grid sizes
%               'range'  -  'full' for use full z-range starting at layer 
%                              bottom and/or top for automatic grid size
%  Output
%    z1       :  adjusted range of z1-values
%    z2       :  adjusted range of z2-values

%  get layer indices
i1 = indlayer( obj, z1( 1 ) );
i2 = indlayer( obj, z2( 1 ) );
%  layer boundaries
zlayer = horzcat( [ obj.z( : ); -Inf ], [ Inf; obj.z( : ) ] );

%  enlarge z-region
z1 = enlarge( z1, zlayer( i1, : ), op );
z2 = enlarge( z2, zlayer( i2, : ), op );

%  number of layers
n = numel( obj.z ) + 1;
%  handle uppermost and lowermost layer separately
if i1 == 1 && i2 == 1
  z1 = z1 + z2 - obj.z( 1   );  z2 = obj.z( 1   ) + 1e-10;
elseif i1 == n && i2 == n
  z1 = z1 + z2 - obj.z( end );  z2 = obj.z( end ) - 1e-10;
end



function z = enlarge( z, zlayer, op )
%  ENLARGE - Enlarge z-region for tabulation.

if abs( z( 1 ) - z( 2 ) ) < 1e-10
  z = z( 1 ) + [ - 1, 1 ] * 1e-2;
else
  z = mean( z ) + [ 1, - 1 ] * 0.5 * op.scale * ( z( 1 ) - z( 2 ) );
end
%  ensure that enlarged z-values are within the layer bounds
if z( 1 ) < zlayer( 1 ),  z( 1 ) = zlayer( 1 ) + 1e-10;  end
if z( 2 ) > zlayer( 2 ),  z( 2 ) = zlayer( 2 ) - 1e-10;  end

%  expand to full range
if isfield( op, 'range' ) && strcmp( op.range, 'full' )
  if ~isinf( zlayer( 1 ) ),  z( 1 ) = zlayer( 1 ) + 1e-10;  end
  if ~isinf( zlayer( 2 ) ),  z( 2 ) = zlayer( 2 ) - 1e-10;  end
end
