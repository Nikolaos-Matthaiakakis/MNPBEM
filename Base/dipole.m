function exc = dipole( varargin )
%  Initialize dipole excitation.
%  
%  Usage :
%    exc = dipole( pt, dip,             PropertyName, PropertyValue )
%    exc = dipole( pt, dip, 'full', op, PropertyName, PropertyValue )      
%  Input
%    pt            :  compound of points (or compoint) for dipole positions      
%    dip           :  directions of dipole moments
%    op            :  options 
%    PropertyName  :  additional properties

%  find option structure
for i = 1 : length( varargin )
  if isstruct( varargin{ i } ),  ind = i;  break;  end
end

%  find plane wave excitation
class = bembase.find( 'dipole', varargin{ ind : end } );
%  check for suitable class
if isempty( class ),  error( 'no class for options structure found' );  end
%  initialize BEM solver
exc = feval( class, varargin{ : } );
