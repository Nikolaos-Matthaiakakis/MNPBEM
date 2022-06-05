function exc = electronbeam( varargin )
%  Initialize electron excitation for EELS simulation.
%  
%  Usage :
%    exc = electronbeam( p, impact, width, vel, op, PropertyPair )
%  Input
%    p              :  particle object for EELS measurement      
%    impact         :  impact parameter of electron beam
%    width          :  width of electron beam for potential smearing
%    vel            :  electron velocity in units of speed of light   
%    op             :  option structre
%    PropertyName   :  additional properties

%  find option structure
for i = 1 : length( varargin )
  if isstruct( varargin{ i } ),  ind = i;  break;  end
end

%  find plane wave excitation
class = bembase.find( 'eels', varargin{ ind : end } );
%  check for suitable class
if isempty( class ),  error( 'no class for options structure found' );  end
%  initialize BEM solver
exc = feval( class, varargin{ : } );
