function exc = planewave( varargin )
%  Initialize plane wave excitation.
%  
%  Usage :
%    exc = planewave( pol,      op, PropertyName, PropertyValue )
%    exc = planewave( pol, dir, op, PropertyName, PropertyValue )      
%  Input
%    pol              :  light polarization
%    op               :  options 
%    PropertyName     :  additional properties

%  find option structure
for i = 1 : length( varargin )
  if isstruct( varargin{ i } ),  ind = i;  break;  end
end

%  find plane wave excitation
class = bembase.find( 'planewave', varargin{ ind : end } );
%  check for suitable class
if isempty( class ),  error( 'no class for options structure found' );  end
%  initialize BEM solver
exc = feval( class, varargin{ : } );
