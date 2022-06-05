function obj = init( obj, epsin, epsout, diameter, varargin )
%  Initialize spherical particle for quasistatic Mie theory.
%  
%  Usage for obj = miestat :
%    obj = init( obj, epsin, epsout, diameter )
%    obj = init( obj, epsin, epsout, diameter, op, PropertyPair )      
%  Input
%    epsin    :  dielectric functions  inside of sphere
%    epsout   :  dielectric functions outside of sphere      
%    diameter :  sphere diameter
%    op       :  options
%    PropertyName     :  additional properties
%                          either OP or PropertyName can contain a
%                          field 'lmax' that determines the maximum
%                          number for spherical harmonic degrees

%  save input parameters
[ obj.epsin, obj.epsout, obj.diameter ] = deal( epsin, epsout, diameter );

%  create or extract option array
if isempty( varargin ) || ~isstruct( varargin{ 1 } )
  op = struct;
else
  [ op, varargin ] = deal( varargin{ 1 }, varargin( 2 : end ) );
end

%  get Mie options
op = getbemoptions( op, { 'mie', 'miestat' }, varargin{ : } );
%  initialize table with angular orders
if ~isfield( op, 'lmax' )
  [ obj.ltab, obj.mtab ] = sphtable(   20 );
else
  [ obj.ltab, obj.mtab ] = sphtable( op.lmax );
end
