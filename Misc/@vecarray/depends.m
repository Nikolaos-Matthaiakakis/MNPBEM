function is = depends( obj, varargin )
%  DEPENDS - Checks whether object uses one of the given properties
%
%  Usage for obj = vecarray :
%    is = depends( obj, property1, property2, ... )
%  Input
%    property   :  properties, 'fun', 'ind', 'scale', or 'sfun'
%  Output
%    is         :  true if object depends on properties

if any( strcmp( 'ind', varargin ) ) && ispage( obj )
  is = true;
elseif any( strcmp( 'fun',   varargin ) ) ||  ...
       any( strcmp( 'scale', varargin ) ) ||  ...
       any( strcmp( 'sfun',  varargin ) )
  is = true;
else
  is = false;
end
