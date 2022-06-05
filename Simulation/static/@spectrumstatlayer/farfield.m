function [ field, k ] = farfield( obj, sig, dir )
%  FARFIELD - Electromagnetic fields of surface charge distribution.
%
%  Usage for obj = spectrumstatlayer :
%    field = farfield( obj, sig, dir )
%  Input
%    sig    :  surface charge distribution
%    dir    :  light propagation direction 
%                (surface normals of unit sphere on default )
%  Output
%    field  :  compstruct object that holds scattered far-fields
%    k      :  wavenumber of light in medium

if ~exist( 'dir', 'var' );  dir = obj.pinfty.nvec;  end

%  make compstruct object
field = compstruct( obj.pinfty, sig.enei );

%  dipole moment of surface charge distribution
dip = matmul( bsxfun( @times, sig.p.pos, sig.p.area ) .', sig.sig ) .';
%  electric field
[ field.e, k ] = efarfield( obj, dip, sig.enei, dir );
%  refractive index
nb = sqrt( k / ( 2 * pi / sig.enei ) );
%  magnetic field in the far-zone, Jackson Eq. (9.19)
field.h = matmul( diag( nb ), matcross( dir, field.e ) );
