function field = farfield( obj, spec, enei )
%  FARFIELD - Electromagnetic fields of dipoles in the far-field limit.
%    
%  Usage for obj = dipolestatlayer :
%    field = farfield( obj, spec, enei )
%  Input
%    enei   :  wavelength of light in vacuum
%    spec   :  SPECTRUMSTATLAYER object 
%  Output
%    field  :  compstruct object that holds far-fields

%  make compstruct object
field = compstruct( spec.pinfty, enei );

%  normal vectors of unit sphere at infinity
dir = spec.pinfty.nvec;
%  electric far fields
[ field.e, k ] = efarfield( spec, obj.dip.dip, enei, dir );
%  refractive index
nb = sqrt( k / ( 2 * pi / enei ) );
%  magnetic field in the far-zone, Jackson Eq. (9.19)
field.h = matmul( diag( nb ), matcross( dir, field.e ) );
