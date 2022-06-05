function field = field( obj, sig, inout )
%  Electric and magnetic field inside/outside of particle surface.
%
%  Usage for obj = bemretiter :
%    field = field( obj, sig, inout )
%  Input
%    sig        :  COMPSTRUCT object with surface charges
%    inout      :  electric field inside (inout = 1) or
%                                outside (inout = 2, default) of particle
%  Output
%    field      :  COMPSTRUCT object with electric and magnetic fields

if ~exist( 'inout', 'var' ),  inout = 2;  end

%  We compute the electric fields using only the surface derivatives and
%  interpolating the potentials and performing numerical derivatives for
%  the tangential derivatives within the boundary elements.  Note that the
%  results for the tangential electric fields are only approximate.

matmul = @( x, y ) reshape( x * reshape( y, size( y, 1 ), [] ), size( y ) );
%  wavenumber of light in vacuum
k = 2 * pi / sig.enei;
%  potential
pot = potential( obj, sig, inout );

%  extract fields
if isfield( pot, 'phi1' )
  [ phi, phip, a, ap ] = deal( pot.phi1, pot.phi1p, pot.a1, pot.a1p );
else
  [ phi, phip, a, ap ] = deal( pot.phi2, pot.phi2p, pot.a2, pot.a2p );
end

%  tangential directions of electric and magnetic field are computed by
%  interpolation of potential to vertices and performing an approximate
%  tangential derivative
[ phi1, phi2     ] = deriv( obj.p, interp( obj.p, phi ) );
[ a1, a2, t1, t2 ] = deriv( obj.p, interp( obj.p, a   ) );

%  normal vector
nvec = cross( t1, t2 );
%  decompose into norm and unit vector
h = sqrt( dot( nvec, nvec, 2 ) );  nvec = bsxfun( @rdivide, nvec, h );
%  tangential vectors
tvec1 =   bsxfun( @rdivide, cross( t2, nvec, 2 ), h );
tvec2 = - bsxfun( @rdivide, cross( t1, nvec, 2 ), h );

%  electric field
e = 1i * k * a -  ...
  outer( nvec, phip ) - outer( tvec1, phi1 ) - outer( tvec2, phi2 );
%  magnetic field
h = matcross( tvec1, a1 ) + matcross( tvec2, a2 ) + matcross( nvec, ap );

%  set output
field = compstruct( obj.p, sig.enei, 'e', e, 'h', h );
