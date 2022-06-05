function [] = getfields( param, varargin )
%  GETFIELDS - Assign the fields of a structure in the calling program.

name = fieldnames( param );
for i = 1 : length( name )
  if isempty( varargin ) || any( strcmp( name{ i }, varargin ) )
    assignin( 'caller', name{ i }, getfield( param, name{ i } ) );
  end
end
