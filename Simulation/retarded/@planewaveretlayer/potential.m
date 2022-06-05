function exc = potential( obj, p, enei )
%  POTENTIAL - Potential of plane wave excitation for use in BEMRETLAYER.
%
%  Usage for obj = planewaveretlayer :
%    exc = potential( obj, p, enei )
%  Input
%    p          :  points or particle surface where potential is computed
%    enei       :  light wavelength in vacuum
%  Output
%    exc        :  compstruct array which contains the scalar and vector
%                  potentials, as well as their surface derivatives

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
%  positions and displaced positions
pos1 = p.pos( ind, : );                           
pos2 = p.pos( ind, : ) + eta * p.nvec( ind, : ); 

%  initialize output arrays
phi = zeros( p.n,    size( obj.dir, 1 ) );  phip = phi;
a   = zeros( p.n, 3, size( obj.dir, 1 ) );  ap   = a;
%  initialize excitation array
exc = compstruct( p, enei, 'phi1', phi, 'phi1p', phi, 'a1', a, 'a1p', a,  ...
                           'phi2', phi, 'phi2p', phi, 'a2', a, 'a2p', a );

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
  
  %  reflection and transmission coefficients
  r1 = fresnel( layer, enei, kpar, poslayer( layer, pos1( :, 3 ), z2 ) );
  r2 = fresnel( layer, enei, kpar, poslayer( layer, pos2( :, 3 ), z2 ) );
  
  %  inner product
  in1 = pos1( :, 1 : 2 ) * dir( 1 : 2 ) .' + z2 * dir( 3 );
  in2 = pos2( :, 1 : 2 ) * dir( 1 : 2 ) .' + z2 * dir( 3 );
  %  factors
  fac1 = exp( 1i * k0 * nb * in1 ) / ( 1i * k0 ) * pol;
  fac2 = exp( 1i * k0 * nb * in2 ) / ( 1i * k0 ) * pol;
  
  %  vector potential
  a( ind, 1 : 2, i ) = bsxfun( @times, fac1( :, 1 : 2 ), r1.p );
  a( ind,     3, i ) = fac1( :, 3 ) .* r1.hh;
  %  scalar potential
  phi( ind, i ) = fac1( :, 3 ) .* r1.sh;
  
  %  derivative of vector potential
  ap( ind, 1 : 2, i ) =  ...
    ( bsxfun( @times, fac2( :, 1 : 2 ), r2.p ) - a( ind, 1 : 2, i ) ) / eta;
  ap( ind, 3, i ) = ( fac2( :, 3 ) .* r2.hh - a( ind, 3, i ) ) / eta;
  %  derivative of scalar potential
  phip( ind, i ) = ( fac2( :, 3 ) .* r2.sh - phi( ind, i ) ) / eta;
  
  %  vector potential and surface derivative for direct excitation
  a0 = exp( 1i * k0 * nb * p.pos( indb, : ) * dir .' ) / ( 1i * k0 ) * pol;
  a0p = bsxfun( @times, a0, 1i * k0 * nb * p.nvec( indb, : ) * dir .' );   
  %  add to reflected potentials
  a(  indb, :, i ) = a(  indb, :, i ) + a0;
  ap( indb, :, i ) = ap( indb, :, i ) + a0p;    
    
end

%  assign scalar potentials to output array
exc.phi1( ind1, : ) = phi( ind1, : );  exc.phi1p( ind1, : ) = phip( ind1, : );
exc.phi2( ind2, : ) = phi( ind2, : );  exc.phi2p( ind2, : ) = phip( ind2, : );
%  assign vector potentials to output array
exc.a1( ind1, :, : ) = a( ind1, :, : );  exc.a1p( ind1, :, : ) = ap( ind1, :, : );
exc.a2( ind2, :, : ) = a( ind2, :, : );  exc.a2p( ind2, :, : ) = ap( ind2, :, : );


function pos = poslayer( layer, z1, z2 )
%  POSLAYER - Positions for layer structure.
pos = struct( 'r', 0, 'z1', z1, 'z2', z2 );
%  layer index
pos.ind1 = indlayer( layer, z1 );
pos.ind2 = indlayer( layer, z2 );
