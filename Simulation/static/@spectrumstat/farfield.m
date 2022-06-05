function [ field, k ] = farfield( obj, sig, dir )
%  FARFIELD - Electromagnetic fields of surface charge distribution.
%
%  Usage for obj = spectrumstat :
%    field = farfield( obj, sig, dir )
%  Input
%    sig    :  surface charge distribution
%    dir    :  light propagation direction 
%                (surface normals of unit sphere on default )
%  Output
%    field  :  compstruct object that holds scattered far-fields
%    k      :  wavenumber of light in medium

if ~exist( 'dir', 'var' );  dir = obj.pinfty.nvec;  end

%  particle surface
p = sig.p;
%  wavenumber of light in medium
[ epsb, k ] = p.eps{ obj.medium }( sig.enei );
%  refractive index
nb = sqrt( epsb );

%  dipole moment of surface charge distribution
dip = matmul( bsxfun( @times, sig.p.pos, sig.p.area ) .', sig.sig );

%  expand direction and dipole moment
dir = repmat( reshape( dir, [], 3, 1 ), [ 1, 1, size( dip, 2 ) ] );
dip = repmat( reshape( dip, 1, 3, [] ), [ size( dir, 1 ), 1, 1 ] );
%  make compstruct object
try
  field = compstruct(  ...
    comparticle( sig.p.eps, { obj.pinfty }, obj.medium ), sig.enei );
catch
  field = compstruct( obj.pinfty, sig.enei );
end
%  magnetic and electric field in the far-zone, Jackson Eq. (9.19)
field.h = nb * k ^ 2 * cross( dir, dip, 2 );
field.e = - cross( dir, field.h, 2 ) / nb;
