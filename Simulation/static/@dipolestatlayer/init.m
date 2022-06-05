function obj = init( obj, pt, varargin )
%  INIT - Initialize dipole moments.
%
%  Usage for obj = dipolestatlayer :
%    obj = init( obj, pt, varargin )
%      set dipole moments eye( 3 ) at all positions
%    obj = init( obj, pt, dip, varargin )
%      set dipole moments dip at all positions
%    obj = init( obj, pt, dip, 'full', varargin )
%      set user-defined dipole moments
%  Input
%    pt     :  compound of points (or compoints) for dipole positions

%  initialize dipole
obj.dip = dipolestat( pt, varargin{ : } );

%  remove dipole moments from VARARGIN
if ~isempty(  varargin ) &&  ...
    isnumeric( varargin{ 1 } ),  varargin = varargin( 2 : end );  end
%  extract input
op = getbemoptions(  ...
  { 'dipole', 'dipolestat', 'dipolestatlayer' }, varargin{ : } );
%  save input arguments
obj.varargin = varargin;
%  layer structure 
obj.layer = op.layer;
%  make sure that points are located above substrate
assert( all( pt.pos( :, 3 ) > obj.layer.z ) );

%  positions and dipole orientations
[ pos, dip ] = deal( obj.dip.pt.pos, obj.dip.dip );
%  positions and moments of image dipole
%    the PT argument of the mirror dipole must have the table of dielectric
%    functions, so we use PT as a template
pos( :, 3 ) =  obj.layer.z - ( pos( :, 3 ) - obj.layer.z );
dip( :, 3, : ) = - dip( :, 3, : );
%  mirror dipoles
obj.idip = dipolestat( compoint( pt.pin, pos, 'layer', pt.layer ),  ...
                                         dip, 'full',  varargin{ : } );

%  initialize spectrum
if isfield( op, 'pinfty' )
  obj.spec = spectrumstatlayer( op.pinfty, 'layer', obj.layer );  
else
  obj.spec = spectrumstatlayer(            'layer', obj.layer );  
end
