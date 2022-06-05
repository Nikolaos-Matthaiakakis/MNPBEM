function obj = init( obj, pol, dir, varargin )
%  Initialize plane wave excitation.
%  
%  Usage :
%    obj = planewaveret( pol, dir )
%    obj = planewaveret( pol, dir, op, PropertyPair )
%  Input
%    pol      :  light polarization
%    dir      :  light propagation direction
%    op               :  options 
%    PropertyName     :  additional properties
%                          either OP or PropertyName can contain fields
%                          'layer' or 'pinfty' that select the layer
%                          structure or the sphere at infinity

%  assert that polarization and light propagation direction are orthogonal
assert( ~any( dot( pol, dir, 2 ) ) );
      
%  extract input
op = getbemoptions(  ...
  { 'planewave', 'planewaveret', 'planewaveretlayer' }, varargin{ : } );

%  save polarization and light propagation direction
[ obj.pol, obj.dir ] = deal( pol, dir );
%  layer structure
obj.layer = op.layer;
%  initialize spectrum
if isfield( op, 'pinfty' )
  obj.spec = spectrumretlayer( op.pinfty, 'layer', obj.layer );  
else
  obj.spec = spectrumretlayer(            'layer', obj.layer );  
end

