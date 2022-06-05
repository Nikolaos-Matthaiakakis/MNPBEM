function obj = init( obj, p, varargin )
%  Initialize quasistatic BEM solver.
%
%  Usage for obj = bemstatmirror :
%    obj = init( obj, p,       op )
%    obj = init( obj, p, enei, op )
%  Input
%    p    :  compound of particles with mirror symmetry
%    enei :  light wavelength in vacuum
%    op   :  option structure

%  save particle
obj.p = p;

%  handle calls with and without ENEI
if ~isempty( varargin ) && isnumeric( varargin{ 1 } )
  [ enei, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end
%  option array
if isempty( varargin ),  varargin = { struct };  end    

%  Green function
obj.g = compgreenstatmirror( p, p, varargin{ : } );
%  surface derivative of Green function
obj.F = subsref( obj.g, substruct( '.', 'F' ) );
%  initialize for given wavelength
if exist( 'enei', 'var' ) && ~isempty( enei )
  obj = subsref( obj, substruct( '()', { enei } ) );
end
