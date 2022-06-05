function exc = field( obj, p, enei, inout )
%  Electromagnetic fields for EELS excitation (infinite beam).
%
%  Usage for obj = eelsret :
%    exc = field( obj, p, enei, inout )
%  Input
%    p          :  points or particle surface where field is computed
%    enei       :  light wavelength in vacuum
%    inout      :  compute field at in- or out-side of p (inout = 1 on default)
%  Output
%    exc        :  COMPSTRUCT object which contains the electromagnetic
%                  fields for an infinite beam, the last dimension
%                  corresponding to the impact parameters 

if ~exist( 'inout', 'var' );  inout = 1;  end

%  number of impact parameters
nimp = size( obj.impact, 1 );
%  index to materials crossed by electron beam
if ~isempty( obj.indimp )
  ind = accumarray( { obj.indimp, obj.indmat }, 0 * obj.indimp + 1,  ...
                                        [ nimp, numel( obj.p.eps ) ] );
else
  ind = zeros( [ nimp, numel( obj.p.eps ) ] );
end
%  all electron beams propagate through embedding medium
ind( :, 1 ) = 1;

%  external excitation
exc = compstruct( p, enei );
%  allocate arrays for electromagnetic fields
exc.e = zeros( p.n, 3, nimp );
exc.h = zeros( p.n, 3, nimp );

%  dielectric functions and wavenumbers
[ eps, k ] = cellfun( @( eps ) ( eps( enei ) ), p.eps );

%  loop over collections of points
for ip = 1 : p.np
  %  index to material
  imat = p.inout( ip, inout );
  %  index to points
  ind1 = p.index( ip );
  %  index to beams located in medium
  ind2 = find( ind( :, imat ) ~= 0 );
  
  %  electromagnetic fields
  [ exc.e( ind1, :, ind2 ), exc.h( ind1, :, ind2 ) ] = fieldinfty(  ...
    p.pos( ind1, : ), obj.impact( ind2, : ), k( imat ), eps( imat ), obj.vel, obj.width );
end


function [ e, h ] = fieldinfty( pos, b, k, eps, vel, width )
%  FIELDINFTY - Fields for infinite electron beam.
%    See F. J. Garcia de Abajo, Rev. Mod. Phys. 82, 209 (2010), Eqs. (5,6).

%  lateral distance vector
x = bsxfun( @minus, repmat( pos( :, 1 ), 1, size( b, 1 ) ), b( :, 1 ) .' );
y = bsxfun( @minus, repmat( pos( :, 2 ), 1, size( b, 1 ) ), b( :, 2 ) .' );
%  parallel component
z = repmat( pos( :, 3 ), 1, size( b, 1 ) );

%  distance
r = sqrt( x .^ 2 + y .^ 2 + width ^ 2 );
%  unit vector
[ x, y ] = deal( x ./ r, y ./ r );

%  allocate array for electromagnetic fields
e = zeros( size( x, 1 ), 3, size( b, 1 ) );
h = zeros( size( x, 1 ), 3, size( b, 1 ) );
%  wavenumber of electron
q = k / ( vel * sqrt( eps ) );
%  Lorentz contraction factor
gamma = 1 ./ sqrt( 1 - eps * vel ^ 2 );

%  Bessel functions
K0 = besselk( 0, q * r / gamma );
K1 = besselk( 1, q * r / gamma );
%  prefactor
fac = 2 * q / ( vel * gamma ) * exp( 1i * q * z );

%  electric field
e( :, 1, : ) = - fac / eps .* K1 .* x;
e( :, 2, : ) = - fac / eps .* K1 .* y;
e( :, 3, : ) =   fac / eps .* K0 * 1i / gamma;
%  magnetic field
h( :, 1, : ) =   vel * fac .* K1 .* y;
h( :, 2, : ) = - vel * fac .* K1 .* x;
