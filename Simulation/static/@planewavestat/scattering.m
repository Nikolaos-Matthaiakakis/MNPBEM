function sca = scattering( obj, sig )
%  SCATTERING - Scattering cross section for plane wave excitation.
%
%  Usage for obj = planewavestat :
%    sca = scattering( obj, sig )
%  Input
%    sig        :  compstruct object containing surface charge
%  Output
%    sca        :  scattering cross section

%  induced dipole moment
dip = matmul( ( repmat( sig.p.area, [ 1, 3 ] ) .* sig.p.pos )',  sig.sig );
%  dielectric function and wavenumber
eps = sig.p.eps{ obj.medium };
[ ~, k ] = eps( sig.enei );
%  scattering cross section
sca = 8 * pi / 3 * k .^ 4 .* sum( abs( dip ) .^ 2, 1 );
