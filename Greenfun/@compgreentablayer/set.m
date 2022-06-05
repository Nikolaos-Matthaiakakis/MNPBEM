function obj = set( obj, enei, varargin )
%  SET - Precompute Green function table for given wavelengths.
%
%  Usage for obj = compgreentablayer :
%    obj = set( obj, enei, PropertyPairs )
%  Input
%    enei               :  wavelengths of light in vacuum
%  PropertyPairs
%    'waitbar'          :  plot waitbar during initialization
%  Output
%    obj                :  precomputed Green function table

%  number of elements
n = cellfun( @( g ) g.numel, obj.g );  
%  range for waitbarlimits
limits = [ 0, cumsum( n ) ];  limits = limits / max( limits );

%  loop over Green functions
for i = 1 : length( obj.g )
  %  precompute Green function table for given wavelengths
  obj.g{ i } = set( obj.g{ i }, enei, varargin{ : },  ...
                     'waitbarlimits', limits( [ i, i + 1 ] ) );
end
