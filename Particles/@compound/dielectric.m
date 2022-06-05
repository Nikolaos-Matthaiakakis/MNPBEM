function eps = dielectric( obj, enei, inout )
%  DIELECTRIC - Dielectric function at in- or outside.
%
%  Usage for obj = compound :
%    eps = dielectric( obj, enei, inout )
%  Input
%    enei   :  wavelength of light in vacuum
%    inout  :  inside (1) or outside (2)
%  Output
%    eps    :  dielectric function at in- or outside

%  table of dielectric functions
eps = cellfun( @( eps ) ( eps( enei ) ), obj.eps, 'UniformOutput', false );
%  in- or outside component
if numel( obj.inout ) ~= numel( obj.p )
  eps = eps( :, obj.inout( :, inout ) );
end
