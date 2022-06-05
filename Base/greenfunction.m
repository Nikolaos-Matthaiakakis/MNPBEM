function g = greenfunction( varargin )
%  Initialize Green function.
%  
%  Usage :
%    g = greenfunction( p1, p2      PropertyName, PropertyValue )
%    g = greenfunction( p1, p2, op, PropertyName, PropertyValue )      
%  Input
%    p1            :  Green function between points p1 and comparticle p2
%    p2            :  Green function between points p1 and comparticle p2
%    op            :  options 
%    PropertyName  :  additional properties

%  find option structure
for i = 1 : length( varargin )
  if isstruct( varargin{ i } ),  ind = i;  break;  end
end

%  find plane wave excitation
class = bembase.find( 'greenfunction', varargin{ ind : end } );
%  check for suitable class
if isempty( class ),  error( 'no class for options structure found' );  end
%  initialize BEM solver
g = feval( class, varargin{ : } );
