function field = farfield( obj, sig, dir )
%  FARFIELD - Electromagnetic fields of surface charge distribution.
%
%  Usage for obj = spectrumretlayer :
%    field = farfield( obj, sig, dir )
%  Input
%    sig    :  surface charge distribution
%    dir    :  light propagation direction 
%                (surface normals of unit sphere on default )
%  Output
%    field  :  compstruct object that holds scattered far-fields

if ~exist( 'dir', 'var' );  dir = obj.pinfty.nvec;  end

%  layer structure and particle
[ layer, p ] = deal( obj.layer, sig.p );
%  wavenumber of light 
[ ~, k ] = cellfun( @( eps ) eps( sig.enei ), layer.eps );
%  upper and lower medium of layer structure
medium = layer.ind( [ 1, end ] );
%  index to propagation directions
[ ind1, ind2 ] = deal( dir( :, 3 ) >= 0, dir( :, 3 ) < 0 ); 

%%  reflected/transmitted fields
%  size of surface current
siz = size( sig.h2 );
%  allocate vector potential at infinity
a = zeros( [ size( dir, 1 ), siz( 2 : end ) ] );
%  boundary elements connected to layer structure
ind = any( bsxfun( @eq, p.expand( num2cell( p.inout( :, 2 ) ) ), layer.ind ), 2 );

%  z-values of particle centroids
z2 = sig.p.pos( ind, 3 );
%  position structure for calculation of reflection/transmission coefficients
pos1 = struct( 'z1', layer.z(   1 ), 'ind1', 1,           'z2', z2, 'ind2', indlayer( layer, z2 ) );
pos2 = struct( 'z1', layer.z( end ), 'ind1', layer.n + 1, 'z2', z2, 'ind2', indlayer( layer, z2 ) );

if imag( k( 1 ) ) == 0 && ~isempty( ind1 )
  %  loop over positive propagation directions 
  for i = reshape( find( ind1 ), 1, [] )
    %  parallel wavevector component for stationary phase expansion
    kpar = k( 1 ) * sqrt( 1 - dir( i, 3 ) ^ 2 );
    %  reflection/transmission coefficients
    r = reflection( layer, sig.enei, kpar, pos1 );
    %  distance difference in phase factor
    dist = p.pos( ind, 1 : 2 ) * transpose( dir( i, 1 : 2 ) ) +  ...
                                    obj.layer.z( 1 ) * dir( i, 3 );
    %  phase factor
    phase = transpose( exp( - 1i * k( 1 ) * dist ) .* p.area( ind ) );
    %  vector potential at infinity
    %    we assume that only the outer surface is connected to layer
    a( i, 1, : ) = ( r.p  .* phase ) * squeeze( sig.h2( ind, 1, : ) );
    a( i, 2, : ) = ( r.p  .* phase ) * squeeze( sig.h2( ind, 2, : ) );
    a( i, 3, : ) = ( r.hh .* phase ) * squeeze( sig.h2( ind, 3, : ) ) +  ...
                   ( r.hs .* phase ) * sig.sig2( ind , : ); 
  end
end

if imag( k( end ) ) == 0 && ~isempty( ind2 )
  %  loop over negative propagation directions 
  for i = reshape( find( ind2 ), 1, [] )
    %  parallel wavevector component for stationary phase expansion
    kpar = k( end ) * sqrt( 1 - dir( i, 3 ) ^ 2 );
    %  reflection/transmission coefficients
    r = reflection( layer, sig.enei, kpar, pos2 );
    %  distance difference in phase factor
    dist = p.pos( ind, 1 : 2 ) * transpose( dir( i, 1 : 2 ) ) +  ...
                                    obj.layer.z( end ) * dir( i, 3 );  
    %  phase factor
    phase = transpose( exp( - 1i * k( end ) * dist ) .* p.area( ind ) );
    %  vector potential at infinity
    a( i, 1, : ) = ( r.p  .* phase ) * squeeze( sig.h2( ind, 1, : ) );
    a( i, 2, : ) = ( r.p  .* phase ) * squeeze( sig.h2( ind, 2, : ) );
    a( i, 3, : ) = ( r.hh .* phase ) * squeeze( sig.h2( ind, 3, : ) ) +  ...
                   ( r.hs .* phase ) * sig.sig2( ind, : );               
  end
end

%  wavenumber of light in vacuum
k0 = 2 * pi / sig.enei;
%  electric field
e = 1i * k0 * a;

%%  direct fields
%  free fields in upper and lower medium
field1 = farfield( spectrumret( obj.pinfty, 'medium', medium( 1 ) ), sig, dir( ind1, : ) );
field2 = farfield( spectrumret( obj.pinfty, 'medium', medium( 2 ) ), sig, dir( ind2, : ) );
%  add to reflected/transmitted fields
e( ind1, :, : ) = e( ind1, :, : ) + field1.e( :, :, : );
e( ind2, :, : ) = e( ind2, :, : ) + field2.e( :, :, : );

%%  final output
%  make electric field transversal
e = e - outer( dir, inner( dir, e ) );

%  allocate magnetic field
h = zeros( size( e ) );
%  expand direction
idir = repmat( reshape( dir, [ size( dir ), 1 ] ),  ...
                             [ 1, 1, size( sig.h1( :, :, : ), 3 ) ] );
%  magnetic field
h( ind1, :, : ) = k(   1 ) / k0 * cross( idir( ind1, :, : ), e( ind1, :, : ), 2 );
h( ind2, :, : ) = k( end ) / k0 * cross( idir( ind2, :, : ), e( ind2, :, : ), 2 );

try
  %  upper and lower particle
  p1 = select( obj.pinfty, 'index', ind1 );  ind1 = find( ind1 );
  p2 = select( obj.pinfty, 'index', ind2 );  ind2 = find( ind2 );
  %  save to structure
  field = compstruct(  ...
    comparticle( p.eps, { p1, p2 }, transpose( medium ) ), sig.enei );
catch
  [ ind1, ind2 ] = deal( find( ind1 ), find( ind2 ) );
  %  save to structure
  field = compstruct( obj.pinfty, sig.enei );
end

%  size of output array
siz = size( sig.h2 );
%  rearrange electric fields
field.e = reshape( e( [ ind1; ind2 ], :, : ), [ size( dir, 1 ), siz( 2 : end ) ] );
field.h = reshape( h( [ ind1; ind2 ], :, : ), [ size( dir, 1 ), siz( 2 : end ) ] );

