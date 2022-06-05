function abs = absorption( obj, sig )
%  ABSORPTION - Absorption cross section for plane wave excitation.
%
%  Usage for obj = planewavestatlayer :
%    abs = absorption( obj, sig )
%  Input
%    sig        :  COMPSTRUCT object containing surface charge
%  Output
%    abs        :  absorption cross section

%  (note) this equation only works for non-absorbing layer materials
abs = extinction( obj, sig ) - scattering( obj, sig );

%  (fixme)  
%  One can alternatively compute the absorption cross section directly.
%  With the below implementation we have problems when the nanoparticle is
%  illuminated from below.  In this case, one should multiply the
%  absorption cross section with eps{ 1 }( enei ) / eps{ end }( sig.enei )
%  in order to fulfill the sum rule cext = cabs + csca or to get agreement
%  with simulations where the absorption cross section is computed via the
%  Poynting vector.

% %  dipole moment of surface charge distribution
% dip = matmul( bsxfun( @times, sig.p.pos, sig.p.area ) .', sig.sig ) .';
% 
% %  incoming electric field
% e = field( obj, struct( 'pos', [ 0, 0, obj.layer.z + 1e-10 ], 'n', 1  ), sig.enei );
% %  extract electric field
% e = transpose( e.e );
% 
% %  wavenumber and dielectric function of incoming medium
% [ ~, k( obj.dir( :, 3 ) < 0 ) ] = obj.layer.eps{ 1   }( sig.enei );
% [ ~, k( obj.dir( :, 3 ) > 0 ) ] = obj.layer.eps{ end }( sig.enei );
% %  absorption cross section
% abs = 4 * pi * k .* imag( dot( e, dip, 2 ) ) .';
