function obj = parset( obj, varargin )
%  SET - Same as SET but with parallel loop.
%
%  Usage for obj = compgreentablayer :
%    obj = set( obj, enei, PropertyPairs )
%  Input
%    enei               :  wavelengths of light in vacuum
%  PropertyPairs
%    'waitbar'          :  plot waitbar during initialization
%  Output
%    obj                :  precomputed Green function table

obj.g = cellfun( @( g ) parset( g, varargin{ : } ), obj.g, 'UniformOutput', false );

