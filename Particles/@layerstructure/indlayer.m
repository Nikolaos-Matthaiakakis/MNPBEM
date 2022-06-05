function [ ind, in ] = indlayer( obj, z )
%  INDLAYER - Find index of layer within which z is embedded.
%
%  Usage for obj = layerstructure :
%    [ ind, in ] = indlayer( obj, z )
%  Input
%    z        :  z-values of points
%  Output
%    ind      :  index to layer within which z is embedded
%    in       :  is point located in layer ?

%  layers are ordered with decreasing z-values
[ ~, ind ] = histc( - z, [ - inf, - obj.z, inf ] );
%  is point located in layer ?
in = abs( mindist( obj, z ) ) < obj.ztol;
