function obj = init( obj, layer, tab )
%  INIT - Initialize Green function object for layer structure.
%  
%  Usage for obj = greentablayer :
%    obj = init( obj, layer, tab )
%  Input
%    layer    :  layer structure
%    tab      :  grids for tabulated r and z-values

obj.layer = layer;
%  save radii
obj.r = unique( sort( max( layer.rmin, tab.r ) ) );
%  save z-values
obj.z1 = unique( sort( round( layer, tab.z1 ) ) );
obj.z2 = unique( sort( round( layer, tab.z2 ) ) );
%  make sure that all z1 values are located within one medium
ind1 = unique( indlayer( layer, tab.z1 ) );  assert( numel( ind1 ) == 1 );
ind2 = unique( indlayer( layer, tab.z2 ) );  assert( numel( ind2 ) == 1 );
