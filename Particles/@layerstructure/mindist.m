function [ zmin, ind ] = mindist( obj, z )
%  MINDIST - Find minimal distance of z-values to layers.
%
%  Usage for obj = layerstructure :
%    [ zmin, ind ] = mindist( obj, z )
%  Input
%    z        :  z-values of points
%  Output
%    zmin     :  minimal distance to layer
%    ind      :  index to nearest layer

%  size of input array
siz = size( z );
%  difference
z = bsxfun( @minus, repmat( z( : ), 1, length( obj.z ) ), obj.z( : ) .' );
%  find minmal distance
[ zmin, ind ] = min( abs( z ), [], 2 );

%  reshape arrays
[ zmin, ind ] = deal( reshape( zmin, siz ), reshape( ind, siz ) );
