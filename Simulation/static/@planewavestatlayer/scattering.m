function [ sca, dsca ] = scattering( obj, sig )
%  SCATTERING - Scattering cross section for plane wave excitation.
%    we use expressions of Novotny & Hecht, Nano Optics (2006), Sec. 10.6
%
%  Usage for obj = planewavestatlayer :
%    [ sca, dsca ] = scattering( obj, sig )
%  Input
%    sig    :  compstruct object containing surface charge
%  Output
%    sca    :  scattering cross section
%    dsca   :  differential cross section

%  dipole moment of surface charge distribution
dip = matmul( bsxfun( @times, sig.p.pos, sig.p.area ) .', sig.sig ) .'; 
%  total and differential radiated power 
[ sca, dsca ] = scattering( obj.spec, dip, sig.enei );

%  refractive indices
nb = sqrt( cellfun( @( eps ) eps( sig.enei ), obj.layer.eps ) );
%  light propagation direction
dir = obj.dir( :, 3 );
%  the scattering cross section is the radiated power normalized to the
%  incoming power, the latter being proportional to 0.5 * epsb * (clight / nb)
sca( dir < 0 ) = sca( dir < 0 ) / ( 0.5 * nb( 1   ) );
sca( dir > 0 ) = sca( dir > 0 ) / ( 0.5 * nb( end ) );
%  differential cross section
dsca.dsca( :, dir < 0 ) = dsca.dsca( :, dir < 0 ) / ( 0.5 * nb( 1   ) );
dsca.dsca( :, dir > 0 ) = dsca.dsca( :, dir > 0 ) / ( 0.5 * nb( end ) );
