function varargout = eval( obj, varargin )
%  EVAL - Evaluate Green function.
%
%  Usage for obj = greenretlayer :
%    varargout = eval( obj,      enei, key1, key2, ... )
%    varargout = eval( obj, ind, enei, key1, key2, ... )
%  Input
%    enei   :  light wavelength in vacuum
%    ind    :  index to matrix elements to be computed
%    key    :  G    -  Green functions
%              F    -  surface derivatives of Green functions
%              Gp   -  derivatives of Green functions
%  Output
%    varargout  :  requested Green functions

%  deal with different calling sequences
if ischar( varargin{ 2 } )
  [ enei, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
  %  initialize reflected Green functions
  obj = initrefl( obj, enei );
else
  [ ind, enei, varargin ] = deal( varargin{ 1 }, varargin{ 2 }, varargin( 3 : end ) );
  %  initialize reflected Green functions
  obj = initrefl( obj, enei, ind );  
end

%  allocate output
varargout = cell( size( varargin ) );

for i = 1 : numel( varargin )
  switch varargin{ i }
    case 'G'
      varargout{ i } = obj.G;
    case 'F'
      varargout{ i } = obj.F;
    case 'Gp'
      varargout{ i } = obj.Gp;
  end
end
