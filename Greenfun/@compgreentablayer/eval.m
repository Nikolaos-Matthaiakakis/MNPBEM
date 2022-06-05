function obj = eval( obj, enei )
%  EVAL - Evaluate table of Green functions for given wavelength.
%
%  Usage for obj = compgreentablayer :
%    obj = eval( obj, enei )
%  Input
%    enei   :  wavelength of light in vacuum
%  Output
%    obj    :  evaluated Green function table

obj.g = cellfun( @( g ) eval( g, enei ), obj.g, 'UniformOutput', false );
