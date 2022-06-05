function bem = bemsolver( p, varargin )
%  BEMSOLVER - Select appropriate BEM solver using options.
%
%  Usage :
%    bem = bemsolver( p,       op, PropertyName, PropertyValue, ... )
%    bem = bemsolver( p, [],   op, PropertyName, PropertyValue, ... )
%    bem = bemsolver( p, enei, op, PropertyName, PropertyValue, ... )
%  Input
%    p    :  compound of particles (see comparticle)
%    enei :  light wavelength in vacuum
%    op   :  options 
%              additional fields of the option array can be passed as
%              pairs of PropertyName and Propertyvalue
%  Output
%    bem  :  BEM solver

%  find BEM solver (deal with different call sequences)
if isstruct( varargin{ 1 } )
  class = bembase.find( 'bemsolver', varargin{ : } );
else
  class = bembase.find( 'bemsolver', varargin{ 2 : end } );
end

%  check for suitable class
if isempty( class ),  error( 'no class for options structure found' );  end
%  initialize BEM solver
bem = feval( class, p, varargin{ : } );
