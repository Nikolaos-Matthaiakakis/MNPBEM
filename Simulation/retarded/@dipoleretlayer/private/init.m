function obj = init( obj, pt, varargin )
%  INIT - Initialize dipole moments.
%
%  Usage for obj = dipoleretlayer :
%    obj = init( obj, pt, varargin )
%      set dipole moments eye( 3 ) at all positions
%    obj = init( obj, pt, dip, varargin )
%      set dipole moments dip at all positions
%    obj = init( obj, pt, dip, 'full', varargin )
%      set user-defined dipole moments
%  Input
%    pt     :  compound of points (or compoints) for dipole positions

%  initialize dipole
obj.dip = dipoleret( pt, varargin{ : } );

%  remove dipole moments from VARARGIN
if ~isempty(  varargin ) &&  ...
    isnumeric( varargin{ 1 } ),  varargin = varargin( 2 : end );  end
%  extract input
op = getbemoptions(  ...
  { 'dipole', 'dipoleret', 'dipoleretlayer' }, varargin{ : } );
%  save input arguments
obj.varargin = varargin;
%  layer structure 
obj.layer = op.layer;
%  table for Green function interpolation
obj.tab = op.greentab;

%  initialize spectrum
if isfield( op, 'pinfty' )
  obj.spec = spectrumretlayer( op.pinfty, 'layer', obj.layer );  
else
  obj.spec = spectrumretlayer(            'layer', obj.layer );  
end
