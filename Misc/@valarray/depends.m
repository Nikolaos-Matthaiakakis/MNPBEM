function is = depends( obj, varargin )
%  DEPENDS - Checks whether object uses one of the given properties
%
%  Usage for obj = valarray :
%    is = depends( obj, property1, property2, ... )
%  Input
%    property   :  properties 'fun' or 'ind'
%  Output
%    is         :  true if object depends on properties

if any( strcmp( 'ind', varargin ) ) && ispage( obj )
  is = true;
elseif any( strcmp( 'fun', varargin ) ) && ~obj.truecolor
  is = true;
else
  is = false;
end
