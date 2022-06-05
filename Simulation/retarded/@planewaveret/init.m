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
%                          either OP or PropertyName can contain
%                          fields 'medium' and 'pinfty' that select
%                          the medium through which the particle is
%                          excited or the unit sphere at infinity

%  save polarization and light propagation direction
[ obj.pol, obj.dir ] = deal( pol, dir );

%  option structure
op = getbemoptions( { 'planewave', 'planewaveret' }, varargin{ : } );

%  get medium
if isfield( op, 'medium' ), obj.medium = op.medium;  end
%  initialize spectrum
if isfield( op, 'pinfty' )
  obj.spec = spectrumret( op.pinfty, 'medium', obj.medium );  
else
  obj.spec = spectrumret( trisphere( 256, 2 ), 'medium', obj.medium );  
end
