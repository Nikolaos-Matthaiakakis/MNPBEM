function obj = init( obj, epsin, epsout, diameter, varargin )
%  Initialize spherical particle for retarded Mie theory.
%  
%  Usage for obj = mieret :
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

%  get Mie options
op = getbemoptions( { 'mie', 'mieret' }, varargin{ : } );
%  initialize table with angular orders
if ~isfield( op, 'lmax' )
  [ obj.ltab, obj.mtab ] = sphtable(   20 );
else
  [ obj.ltab, obj.mtab ] = sphtable( op.lmax );
end
