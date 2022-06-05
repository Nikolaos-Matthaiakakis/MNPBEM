function mie = miesolver( varargin )
%  Initialize solver for Mie theory.
%  
%  Usage :
%    obj = miesolver( epsin, epsout, diameter, op, PropertyPair )      
%  Input
%    epsin    :  dielectric functions  inside of sphere
%    epsout   :  dielectric functions outside of sphere      
%    diameter :  sphere diameter
%    op       :  options
%    PropertyName     :  additional properties
%                          either OP or PropertyName can contain a
%                          field 'lmax' that determines the maximum
%                          number for spherical harmonic degrees

%  find option structure
for i = 1 : length( varargin )
  if isstruct( varargin{ i } ),  ind = i;  break;  end
end

%  find Mie solver
class = bembase.find( 'miesolver', varargin{ ind : end } );
%  check for suitable class
if isempty( class ),  error( 'no class for options structure found' );  end
%  initialize BEM solver
mie = feval( class, varargin{ : } );
