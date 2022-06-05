function obj = initrefl( obj, varargin )
%  INITREFL - Initialize reflected part of Green function.
%
%  Usage for obj = compgreenretlayer :
%    obj = initrefl( obj, enei )
%    obj = initrefl( obj, enei, ind )
%  Input
%    enei   :  wavelength of light in vacuum
%    ind    :  index to selected matrix elements
%  Output
%    obj    :  object with precomputed reflected Green functions

obj.gr = initrefl( obj.gr, varargin{ : } );
