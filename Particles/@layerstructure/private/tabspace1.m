function tab = tabspace1( obj, r, z1, z2, varargin )
%  TABSPACE1 - Compute suitable grids for tabulated r and z-values.
%
%  Usage for obj = layerstructure :
%    tab = tabspace1( obj, r, z1, z2, PropertyPair )
%  Input
%    r        :  radial values [ rmin, rmax, nr ]
%    z1, z2   :  z-values      [ zmin, zmax, nz ]
%  PropertyName
%    'rmod'   :  'log' for logspace r-table (default) or 'lin' for linspace
%    'zmod'   :  'log' for logspace z-table (default) or 'lin' for linspace
%  Output
%    tab.r    :  tabulated radial values
%    tab.z1   :  tabulated z1-values
%    tab.z2   :  tabulated z2-values

%  get options
op = getbemoptions( varargin{ : } );
%  We do something somewhat dirty here.  In some situations it happens that
%  the upper or lower limit of the tabulated Green function and of the
%  interpolation points differ after calling ROUND because of numerical
%  rounding errors.  For this reason, we here reduce the ZMIN value by a
%  small amount.  As consequence, the tabulated z-range will be always
%  larger than the rounded interpolated z-values.
obj.zmin = 0.999 * obj.zmin;

%  default values
if ~isfield( op, 'rmod' ),  op.rmod = 'log';  end
if ~isfield( op, 'zmod' ),  op.zmod = 'log';  end

tab = struct;
%  table for radii
tab.r = linlogspace( max( r( 1 ), obj.rmin ), r( 2 ), r( 3 ), op.rmod );

if numel( z1 ) == 1
  tab.z1 = z1;
else
  %  set z1-value to proper range
  z1( 1 : 2 ) = sort( round( obj, z1( 1 : 2 ) ) );
  %  handle case that z1-range is too small
  if abs( z1( 1 ) - z1( 2 ) ) < 1e-3,  z1 = expand( obj, z1 );  end
  %  table for z1 values
  tab.z1 = zlinlogspace( obj, z1( 1 ), z1( 2 ), z1( 3 ), op.zmod );
end

if numel( z2 ) == 1
  tab.z2 = z2;
else
  %  set z2-value to proper range
  z2( 1 : 2 ) = sort( round( obj, z2( 1 : 2 ) ) );
  %  handle case that z1-range is too small
  if abs( z2( 1 ) - z2( 2 ) ) < 1e-3,  z2 = expand( obj, z2 );  end  
  %  table for z1 values
  tab.z2 = zlinlogspace( obj, z2( 1 ), z2( 2 ), z2( 3 ), op.zmod );
end


function z = expand( obj, z )
%  EXPAND - Expand z-range if too small.

%  find nearest interface
[ ~, ind ] = mindist( obj, z( 1 ) );
%  shift away z-value
z( 1 : 2 ) = sort( [ z( 1 ) + sign( z( 1 ) - obj.z( ind ) ) * 0.1 * obj.zmin, z( 2 ) ] );


function x = linlogspace( xmin, xmax, n, key, x0 )
%  LINLOGSPACE - Make table with linear or logarithmic spacing.
%  
%  Usage :
%    x = linlogspace( xmin, xmax, n, key, offset )
%  Input
%    xmin   :  minimum of x-values
%    xmax   :  maximum of x-values
%    n      :  number of x-values
%    key    :  'log' for logspace or 'lin' for linspace
%    x0     :  offset 
%  Output
%    x      :  table of x-values

switch key
  case 'lin'
    x = linspace( xmin, xmax, n );
  case 'log'
    if ~exist( 'x0', 'var' ),  x0 = 0;  end
    x = x0 + logspace( log10( xmin - x0 ), log10( xmax - x0 ), n );
end


function z = zlinlogspace( obj, zmin, zmax, n, key )
%  ZLINLOGSPACE - Make table for heights.
%  
%  Usage for obj = layerstructure :
%    z = zlinlogspace( obj, zmin, zmax, n, key, ind, dmin )
%  Input
%    zmin    :  minimum of z-values
%    zmax    :  maximum of z-values
%    n       :  number of z-values
%    key     :  'log' for logspace or 'lin' for linspace
%  Output
%    z       :  table of z-values

%  linear or logarithmic scale
switch key
  case 'lin'
    z = linspace( zmin, zmax, n );
  case 'log'
    %  layer medium
    medium = indlayer( obj, zmin );
    %  upper layer
    if medium == 1   
      z = obj.z( 1 ) + logspace( log10( zmin - obj.z( 1 ) ),  ...
                                 log10( zmax - obj.z( 1 ) ), n );
    %  lower medium
    elseif medium == numel( obj.z ) + 1
      z = obj.z( end ) - logspace( log10( obj.z( end ) - zmax ),  ...
                                   log10( obj.z( end ) - zmin ), n );    
      %  flip array
      z = fliplr( z );
    %  intermediate layer
    else
      %  upper and lower layer
      zup = obj.z( medium - 1 );
      zlo = obj.z( medium     );
      %  z-value scaled to interval [ - 1, 1 ]
      zmin = 2 * ( zmin - zlo ) / ( zup - zlo ) - 1;
      zmax = 2 * ( zmax - zlo ) / ( zup - zlo ) - 1;
      %  table that is logarithmic at both ends
      z = tanh( linspace( atanh( zmin ), atanh( zmax ), n ) );
      %  scale to interval
      z = 0.5 * ( zup + zlo ) + 0.5 * z * ( zup - zlo );
    end
end
