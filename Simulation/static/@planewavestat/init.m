function obj = init( obj, pol, varargin )
%  Initialize plane wave excitation.
%  
%  Usage for obj = planewavestat :
%    obj = init( obj, pol,      op, PropertyName, PropertyValue )
%    obj = init( obj, pol, dir, op, PropertyName, PropertyValue )      
%  Input
%    pol              :  light polarization
%    op               :  options 
%    PropertyName     :  additional properties
%                          either OP or PropertyName can contain a
%                          field 'medium' that selectrs the medium
%                          through which the particle is excited

%  save polarization
obj.pol = pol;

%  remove light propagation direction (if provided)
if ~isempty( varargin ) && numel( varargin{ 1 } ) ~= 1
  varargin = varargin( 2 : end );  
end
%  done ?
if isempty( varargin ),  return;  end
%  option structure
if isstruct( varargin{ 1 } )
  op = getbemoptions( varargin{ 1 }, { 'planewave', 'planewavestat' }, varargin{ 2: end } );
else
  op = getbemoptions( struct, { 'planewave', 'planewavestat' }, varargin{ : } );
end

%  get medium
if isfield( op, 'medium' ), obj.medium = op.medium;  end
