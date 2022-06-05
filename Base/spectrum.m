function spec = spectrum( varargin )
%  Initialize spectrum.
%  
%  Usage :
%    spec = spectrum( pinfty, op, PropertyName, PropertyValue )
%    spec = spectrum( dir,    op, PropertyName, PropertyValue )
%    spec = spectrum(         op, PropertyName, PropertyValue )
%  Input
%    pinfty     :  unit sphere at infinty
%    dir        :  light propagation direction
%  PropertyName
%    'medium'   :  medium for computation of spectrum

%  find option structure
for i = 1 : length( varargin )
  if isstruct( varargin{ i } ),  ind = i;  break;  end
end

%  find spectrum objects
class = bembase.find( 'spectrum', varargin{ ind : end } );
%  check for suitable class
if isempty( class ),  error( 'no class for options structure found' );  end
%  initialize BEM solver
spec = feval( class, varargin{ : } );
