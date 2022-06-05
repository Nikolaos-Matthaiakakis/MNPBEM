function exc = field( obj, p, enei, inout )
%  Electromagnetic fields for dipole excitation.
%
%  Usage for obj = dipoleret :
%    exc = field( obj, enei, inout )
%  Input
%    p          :  points or particle surface where field is computed
%    enei       :  light wavelength in vacuum
%    inout      :  compute field at in- or out-side of p (inout = 1 on default)
%  Output
%    exc        :  COMPSTRUCT object which contains the electromagnetic
%                  fields, the last two dimensions corresponding to the 
%                  positions and dipole moments

if ~exist( 'inout', 'var' ),  inout = 1;  end

%  dipole positions
pt = obj.pt;
%  connectivity between materials
con = connect( p, pt );
%  dielectric functions and wavenumbers
[ eps, k ] = cellfun( @( eps ) ( eps( enei ) ), p.eps );

%  number of dipole orientations
ndip = size( obj.dip, 3 );
%  external excitation
exc = compstruct( p, enei );
%  allocate arrays for electromagnetic fields
exc.e = zeros( p.n, 3, pt.n, ndip );
exc.h = zeros( p.n, 3, pt.n, ndip );

%  positions connected by dielectric media
for ip  = 1 : size( con{ inout }, 1 )
for ipt = 1 : size( con{ inout }, 2 )
  %  index to connecting medium
  ind = con{ inout }( ip, ipt );
  %  are media connected ?
  if ind ~= 0
    %  index to positions of partcile and dipoles
    ind1 =  p.index( ind );  pos1 =  p.pos( ind1, : );
    ind2 = pt.index( ind );  pos2 = pt.pos( ind2, : );
    %  dipole orientations
    dip = obj.dip( ind2, :, : );
    %  compute potentials and surface derivatives
    [ exc.e( ind1, :, ind2, : ), exc.h( ind1, :, ind2, : ) ] =  ...
                      dipolefield( pos1, pos2, dip, eps( ind ), k( ind ) );
   end
end
end


function [ e, h ] = dipolefield( pos1, pos2, dip, eps, k )
%  DIPOLEFIELD - Electromagnetic field for dipole excitation.

%  number of positions
n1 = size( pos1, 1 );
n2 = size( pos2, 1 );
%  position difference
x = repmat( pos1( :, 1 ), 1, n2 ) - repmat( pos2( :, 1 )', n1, 1 );
y = repmat( pos1( :, 2 ), 1, n2 ) - repmat( pos2( :, 2 )', n1, 1 );
z = repmat( pos1( :, 3 ), 1, n2 ) - repmat( pos2( :, 3 )', n1, 1 );
%  radius
r = sqrt( x .^ 2 + y .^ 2 + z .^ 2 );
%  make unit verctor
[ x, y, z ] = deal( x ./ r, y ./ r, z ./ r );


%  Green function and derivative
G = exp( 1i * k * r ) ./ r;

%  number of dipole orientations
ndip = size( dip, 3 );
%  allocate arrays
e = zeros( n1, 3, n2, ndip );  
h = zeros( n1, 3, n2, ndip );

%  loop over dipole orientations
for i = 1 : ndip
  
  %  dipole moment
  dx = repmat( dip( :, 1, i ) .', n1, 1 ); 
  dy = repmat( dip( :, 2, i ) .', n1, 1 ); 
  dz = repmat( dip( :, 3, i ) .', n1, 1 );
  %  inner products
  in = x .* dx + y .* dy + z .* dz;
  
  %  prefactor for magnetic field
  fac = k ^ 2 * G .* ( 1 - 1 ./ ( 1i * k * r ) ) / sqrt( eps );
  %  magnetic field [Jackson (9.18)]
  h( :, 1, :, i ) = fac .* ( y .* dz - z .* dy );
  h( :, 2, :, i ) = fac .* ( z .* dx - x .* dz );
  h( :, 3, :, i ) = fac .* ( x .* dy - y .* dx );
  
  %  prefactors for electric field
  fac1 = k ^ 2 * G / eps;
  fac2 = G .* ( 1 ./ r .^ 2 - 1i * k ./ r ) / eps;
  %  electric field [Jackson (9.18)]
  e( :, 1, :, i ) = fac1 .* ( dx - in .* x ) + fac2 .* ( 3 * in .* x - dx );
  e( :, 2, :, i ) = fac1 .* ( dy - in .* y ) + fac2 .* ( 3 * in .* y - dy );
  e( :, 3, :, i ) = fac1 .* ( dz - in .* z ) + fac2 .* ( 3 * in .* z - dz );
  
end
