function [ phi, a, alpha, De ] = excitation( obj, exc )
%  Compute excitation variables for BEM solver.

%  default values for scalar and vector potential
phi1 = 0;  phi1p = 0;  a1 = 0;  a1p = 0;
phi2 = 0;  phi2p = 0;  a2 = 0;  a2p = 0;
%  get input fields
getfields( exc );

%  wavenumber and dielectric functions
[ k, eps1, eps2 ] = deal( obj.k, obj.eps1, obj.eps2 );
%  outer surface normal
nvec = obj.nvec;

%  external excitation, Garcia de Abajo and Howie, PRB 65, 115418 (2002).

%  Eqs. (10,11)
phi = phi2 - phi1;
a = a2 - a1;
%  Eq. (15)
alpha = a2p - a1p -  ...
    1i * k * ( outer( nvec, phi2, eps2 ) - outer( nvec, phi1, eps1 ) );
%  Eq. (18)
De = matmul( eps2, phi2p ) - matmul( eps1, phi1p ) -  ...
    1i * k * ( inner( nvec, a2, eps2 ) - inner( nvec, a1, eps1 ) );
  
%  expand PHI and A
if numel( phi ) == 1,  phi = zeros( size( De    ) );  end
if numel( a   ) == 1,  a   = zeros( size( alpha ) );  end
