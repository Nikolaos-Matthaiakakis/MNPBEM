function exc = potential( obj, p, enei )
%  POTENTIAL - Potential of dipole excitation for use in bemret.
%
%  Usage for obj = dipoleret :
%    exc = potential( obj, p, enei )
%  Input
%    p          :  points or particle surface where potential is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct array which contains the scalar and vector
%                  potentials, the last two dimensions of the exc fields
%                  correspond to the positions and dipole moments

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
%  allocate arrays for scalar potential
exc.phi1 = zeros( p.n, pt.n, ndip );  exc.phi1p = zeros( p.n, pt.n, ndip );
exc.phi2 = zeros( p.n, pt.n, ndip );  exc.phi2p = zeros( p.n, pt.n, ndip );
%  allocate arrays for vector potential
exc.a1 = zeros( p.n, 3, pt.n, ndip );  exc.a1p = zeros( p.n, 3, pt.n, ndip );
exc.a2 = zeros( p.n, 3, pt.n, ndip );  exc.a2p = zeros( p.n, 3, pt.n, ndip );

%  loop over inside/outside and positions connected by dielectric media
for inout = 1 : length( con )
  for ip  = 1 : size( con{ inout }, 1 )
  for ipt = 1 : size( con{ inout }, 2 )
    %  index to connecting medium
    ind = con{ inout }( ip, ipt );
    %  are media connected ?
    if ind ~= 0
      %  index to positions of particle and dipoles
      ind1 =  p.index( ip  );  pos1 =  p.pos( ind1, : );
      ind2 = pt.index( ipt );  pos2 = pt.pos( ind2, : );
      %  normal vectors and dipole orientations
      nvec = p.nvec( ind1, : );
      dip = obj.dip( ind2, :, : );
      %  compute potentials and surface derivatives
      [ phi, phip, a, ap ] =  ...
                   pot( pos1, pos2, nvec, dip, eps( ind ), k( ind ) );
      %  set output array
      switch inout
        case 1
          exc.phi1(  ind1, ind2, : ) = phi;   exc.a1(  ind1, :, ind2, : ) = a;  
          exc.phi1p( ind1, ind2, : ) = phip;  exc.a1p( ind1, :, ind2, : ) = ap;
        case 2
          exc.phi2(  ind1, ind2, : ) = phi;   exc.a2(  ind1, :, ind2, : ) = a;  
          exc.phi2p( ind1, ind2, : ) = phip;  exc.a2p( ind1, :, ind2, : ) = ap;          
      end
    end
  end
  end
end


function [ phi, phip, a, ap ] = pot( pos1, pos2, nvec, dip, eps, k )
%  POT - Compute potentials and surface derivatives.

%  wavenumber in vacuum
k0 = k / sqrt( eps );

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
F = ( 1i * k - 1 ./ r ) .* G;

%  normal vectors
nx = repmat( nvec( :, 1 ), 1, n2 ); 
ny = repmat( nvec( :, 2 ), 1, n2 );  
nz = repmat( nvec( :, 3 ), 1, n2 );  
%  inner product
en = nx .* x + ny .* y + nz .* z;

%  number of dipole orientations
ndip = size( dip, 3 );
%  allocate arrays
phi  = zeros( n1, n2, ndip );  a  = zeros( n1, 3, n2, ndip );  
phip = zeros( n1, n2, ndip );  ap = zeros( n1, 3, n2, ndip );

%  loop over dipole orientations
for i = 1 : ndip
  %  dipole moment
  dx = repmat( dip( :, 1, i ) .', n1, 1 );
  dy = repmat( dip( :, 2, i ) .', n1, 1 );
  dz = repmat( dip( :, 3, i ) .', n1, 1 ); 
  %  inner products
  ep =  x .* dx +  y .* dy +  z .* dz;
  np = nx .* dx + ny .* dy + nz .* dz;
  
  %  scalar potential and surface derivative
  phi(  :, :, i ) = - ep .* F / eps;
  phip( :, :, i ) =  ...
    ( np - 3 * en .* ep ) ./ r .^ 2 .* ( 1 - 1i * k * r ) .* G / eps +  ...
                                         k ^ 2 * ep .* en .* G / eps;
  %  vector potential [Jackson, Eq. (9.16)]
  a( :, 1, :, i ) = - 1i * k0 * dx .* G;
  a( :, 2, :, i ) = - 1i * k0 * dy .* G;
  a( :, 3, :, i ) = - 1i * k0 * dz .* G;
  %  surface derivative of vector potential
  ap( :, 1, :, i ) = - 1i * k0 * dx .* en .* F;
  ap( :, 2, :, i ) = - 1i * k0 * dy .* en .* F;
  ap( :, 3, :, i ) = - 1i * k0 * dz .* en .* F;
end
