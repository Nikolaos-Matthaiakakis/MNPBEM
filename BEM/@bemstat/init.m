function obj = init( obj, p, varargin )
%  INIT - Initialize quasistatic BEM solver.
%
%  Usage for obj = bemstat :
%    obj = init( obj, p,       op, PropertyName, PropertyValue, ... )
%    obj = init( obj, p, [],   op, PropertyName, PropertyValue, ... )
%    obj = init( obj, p, enei, op, PropertyName, PropertyValue, ... )
%  Input
%    p    :  compound of particles (see comparticle)
%    enei :  light wavelength in vacuum
%    op   :  options 
%              additional fields of the option array can be passed as
%              pairs of PropertyName and Propertyvalue

%  save particle
obj.p = p;

%  handle calls with and without ENEI
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ enei, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end

%  option array
if isempty( varargin ),  varargin = { struct };  end
%  Green function
obj.g = compgreenstat( p, p, varargin{ : } );

%  surface derivative of Green function
obj.F = subsref( obj.g, substruct( '.', 'F' ) );
%  initialize for given wavelength
if exist( 'enei', 'var' ) && ~isempty( enei )
  obj = subsref( obj, substruct( '()', { enei } ) );
end
