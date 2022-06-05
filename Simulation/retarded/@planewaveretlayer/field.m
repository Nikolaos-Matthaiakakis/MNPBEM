function exc = field( obj, p, enei )
%  FIELD - Electromagnetic fields of plane wave excitation.
%
%  Usage for obj = planewaveretlayer :
%    exc = field( obj, p, enei )
%  Input
%    p          :  points or particle surface where potential is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct object for electromagnetic fields

%  layer structure
layer = obj.layer;
%  wavevector of light in vacuum
k0 = 2 * pi / enei;

%  inside and outside medium of particle
inout = p.expand( mat2cell( p.inout, ones( p.np, 1 ), size( p.inout, 2 ) ) );
%  find boundary elements with in- or outside connected to layer structure
ind1 = any( bsxfun( @eq, inout( :, 1   ), layer.ind ), 2 );
ind2 = any( bsxfun( @eq, inout( :, end ), layer.ind ), 2 );
%  boundary elements connected to layer structure
ind = ind1 | ind2;

%  small quantity
eta = 1e-8;
%  initialize output arrays
phi = zeros( p.n,    size( obj.dir, 1 ), 4 );  
a   = zeros( p.n, 3, size( obj.dir, 1 ), 4 ); 

%  loop over propagation directions
for i = 1 : size( obj.dir, 1 )
  
  %  light polarization and propagation direction
  [ pol, dir ] = deal( obj.pol( i, : ), obj.dir( i, : ) );
  
  %  excitation through upper or lower layer
  if dir( 3 ) < 0
    [ medium, z2 ] = deal( layer.ind( 1   ), layer.z( 1   ) + 1e-10 );
  else
    [ medium, z2 ] = deal( layer.ind( end ), layer.z( end ) - 1e-10 );
  end
  
  %  index to embedding medium
  indb = any( inout == medium, 2 );
  %  refractive index of embedding medium
  nb = sqrt( p.eps{ medium }( enei ) );
  %  parallel component of wavevector
  kpar = nb * k0 * norm( dir( 1 : 2 ) );
  
  %  loop over Cartesian directions
  for k = 0 : 3
 
    %  positions connected to layer structure
    pos = p.pos( ind, : );
    %  displaced positions
    if k ~= 0,  pos( :, k ) = pos( :, k ) + eta;  end
  
    %  reflection and transmission coefficients
    r = fresnel( layer, enei, kpar, poslayer( layer, pos( :, 3 ), z2 ) );
    %  inner product and exponential factor
    in = pos( :, 1 : 2 ) * dir( 1 : 2 ) .' + z2 * dir( 3 );
    fac = exp( 1i * k0 * nb * in ) / ( 1i * k0 ) * pol;
  
    %  vector potential
    a( ind, 1 : 2, i, k + 1 ) = bsxfun( @times, fac( :, 1 : 2 ), r.p );
    a( ind,     3, i, k + 1 ) = fac( :, 3 ) .* r.hh;
    %  scalar potential
    phi( ind, i, k + 1 ) = fac( :, 3 ) .* r.sh;

    %  positions for direct excitation
    pos = p.pos( indb, : );
    %  displaced positions
    if k ~= 0,  pos( :, k ) = pos( :, k ) + eta;  end    
    
    %  vector potential and surface derivative for direct excitation
    a0 = exp( 1i * k0 * nb * pos * dir .' ) / ( 1i * k0 ) * pol;
    %  add to reflected potentials
    a( indb, :, i, k + 1 ) = a( indb, :, i, k + 1 ) + a0;
  end
end

%  electric field 
e = 1i * k0 * squeeze( a( :, :, :, 1 ) );
%  derivative function
fun = @( phi, k ) ( 1 / eta ) * reshape(  ...
  phi( :, :, k + 1 ) - phi( :, :, 1 ), [ size( phi, 1 ), 1, size( phi, 2 ) ] );
%  add derivative of scalar potential
e( :, 1, : ) = e( :, 1, : ) - fun( phi, 1 );
e( :, 2, : ) = e( :, 2, : ) - fun( phi, 2 );
e( :, 3, : ) = e( :, 3, : ) - fun( phi, 3 );

%  magnetic field
h = zeros( size( e ) );
%  derivative function, \partial_k A_i
fun = @( a, k, i ) ( 1 / eta ) * reshape(  ...
  a( :, i, :, k + 1 ) - a( :, i, :, 1 ), [ size( a, 1 ), 1, size( a, 3 ) ] );
%  H = rot A
h( :, 1, : ) = fun( a, 2, 3 ) - fun( a, 3, 2 );
h( :, 2, : ) = fun( a, 3, 1 ) - fun( a, 1, 3 );
h( :, 3, : ) = fun( a, 1, 2 ) - fun( a, 2, 1 );

%  output array
exc = compstruct( p, enei, 'e', e, 'h', h );


function pos = poslayer( layer, z1, z2 )
%  POSLAYER - Positions for layer structure.
pos = struct( 'r', 0, 'z1', z1, 'z2', z2 );
%  layer index
pos.ind1 = indlayer( layer, z1 );
pos.ind2 = indlayer( layer, z2 );
