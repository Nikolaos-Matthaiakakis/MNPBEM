function is = ismember( obj, layer, enei )
%  ISMEMBER - Determines whether precomputed table is compatible with parameters.
%
%  Usage for obj = greentablayer :
%    is = ismember( obj, layer )
%    is = ismember( obj, layer, enei )
%  Input
%    layer  :  layer structure
%    enei   :  wavelengths of light in vacuum (optional)
%  Output
%    is     :  TRUE if LAYER and ENEI are compatible with precomputed Green
%              functions, otherwise GREENTABLAYER should be re-initialized

%  default return value
is = false;

%  OBJ.ENEI not set or wavelengths range not compatible
if isempty( obj.enei ) || ( exist( 'enei', 'var' ) &&  ...
  ( min( enei ) < min( obj.enei ) || max( enei ) > max( obj.enei ) ) ),  return;  end

if ( layer.n ~= obj.layer.n ) || ~all( layer.z == obj.layer.z )
  return;
else
  %  evaluate dielectric functions
  eps1 = cell2mat( cellfun( @( eps ) eps( obj.enei ),     layer.eps, 'UniformOutput', false ) );
  eps2 = cell2mat( cellfun( @( eps ) eps( obj.enei ), obj.layer.eps, 'UniformOutput', false ) );
  %  check for inequality
  if norm( eps1 - eps2 ) > 1e-8,  return;  end
end
%  precomputed table is compatible with input parameters
is = true;
