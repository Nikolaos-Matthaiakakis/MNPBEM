function obj = init( obj, pol, dir, varargin )
%  INIT - Initialize plane wave excitation for layer structure
%  
%  Usage for obj = planewavestatlayer :
%    obj = init( obj, pol, dir, op, PropertyName, PropertyValue )      
%  Input
%    pol              :  light polarization
%    op               :  options 
%    PropertyName     :  additional properties
%                          either OP or PropertyName can contain a
%                          field 'medium' that selectrs the medium
%                          through which the particle is excited

%  extract input
op = getbemoptions(  ...
  { 'planewave', 'planewavestat', 'planewavestatlayer' }, varargin{ : } );

%  save polarization and light propagation direction
[ obj.pol, obj.dir ] = deal( pol, dir );
%  assert that polarization and light propagation direction are orthogonal
assert( ~any( dot( obj.pol, obj.dir, 2 ) ) );

%  layer structure
obj.layer = op.layer;
%  initialize spectrum
if isfield( op, 'pinfty' )
  obj.spec = spectrumstatlayer( op.pinfty, 'layer', obj.layer );  
else
  obj.spec = spectrumstatlayer(            'layer', obj.layer );  
end