function obj = init( obj, p, varargin )
%  INIT - Initialize quasistatic, iterative BEM solver.
%
%  Usage for obj = bemstatiter :
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

obj.op = getbemoptions( { 'iter', 'bemiter' }, varargin{ : } );
%  Green function
obj.g = aca.compgreenstat( p, varargin{ : }, 'htol', min( obj.op.htol ), 'kmax', max( obj.op.kmax ) );
%  surface derivative of Green function
obj.F = eval( obj.g, 'F' ); 
obj.F.val = reshape( obj.F.val, [], 1 );
%  add statistics
obj = setstat( obj, 'F', obj.F );

%  initialize for given wavelength
if exist( 'enei', 'var' ) && ~isempty( enei )
  obj = initmat( obj, enei );
end
