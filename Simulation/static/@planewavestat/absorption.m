function abs = absorption( obj, sig )
%  ABSORPTION - Absorption cross section for plane wave excitation.
%
%  Usage for obj = planewavestat :
%    abs = absorption( obj, sig )
%  Input
%    sig        :  compstruct object containing surface charge
%  Output
%    abs        :  absorption cross section

%  induced dipole moment
dip = matmul( ( repmat( sig.p.area, [ 1, 3 ] ) .* sig.p.pos )',  sig.sig );

%  dielectric function and wavenumber
eps = sig.p.eps{ obj.medium };
%  wavenumber
[ ~, k ] = eps( sig.enei );

%  absorption cross section
abs = 4 * pi * k .* imag( dot( transpose( obj.pol ), dip, 1 ) );