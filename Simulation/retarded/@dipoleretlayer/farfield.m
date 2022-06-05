function field = farfield( obj, spec, enei )
%  FARFIELD - Electromagnetic fields of dipoles.
%
%  Usage for obj = dipoleretlayer :
%    field = farfield( obj, spec, sig )
%  Input
%    spec   :  SPECTRUMRETLAYER object 
%    enei   :  wavelength of light in vacuum
%  Output
%    field  :  compstruct object that holds scattered dipolar far-fields

%  normal vectors of unit sphere at infinity
dir = spec.pinfty.nvec;

%  layer structure 
layer = obj.layer;
%  dipole object
dip = obj.dip;
%  dipole positions and moments
[ pt, pos, dip ] = deal( dip.pt, dip.pt.pos, dip.dip );
%  dipole moment reduced by dielectric function of embedding medium
dip2 = matmul( diag( 1 ./ pt.eps2( enei ) ), dip );

%  wavenumber of light in vacuum
k0 = 2 * pi / enei;
%  wavenumber of light 
[ ~, k ] = cellfun( @( eps ) eps( enei ), layer.eps );
%  upper and lower medium of layer structure
medium = layer.ind( [ 1, end ] );
%  index to propagation directions
[ ind1, ind2 ] = deal( dir( :, 3 ) >= 0, dir( :, 3 ) < 0 ); 

%  We compute the dipole potential through finite differences. First,
%  we set up the position array POS2 with dipole positions and positions
%  slightly displaced along the three Cartesian directions, and then
%  compute the potentials and their derivatives.

%  small quantity
eta = 1e-6;
%  displacement function
fun = @( k )  ...
  bsxfun( @plus, pos, accumarray( { 1, k }, eta, [ 1, 3 ] ) );
%  array with positions and displaced positions
pos = cat( 3, pos, fun( 1 ), fun( 2 ), fun( 3 ) );
%  reshape position array
pos = reshape( permute( pos, [ 1, 3, 2 ] ), [], 3 );

%%  reflected/transmitted fields
%  z-values of positions
z2 = pos( :, 3 );
%  position structure for calculation of reflection/transmission coefficients
pos1 = struct( 'z1', layer.z(   1 ), 'ind1', 1,           'z2', z2, 'ind2', indlayer( layer, z2 ) );
pos2 = struct( 'z1', layer.z( end ), 'ind1', layer.n + 1, 'z2', z2, 'ind2', indlayer( layer, z2 ) );

%  allocate vector potential at infinity
a = zeros( [ size( dir, 1 ), 3, numel( dip( :, 1, : ) ) ] );
%  dipole positions connected to layer structure
ind = any( bsxfun( @eq, pt.expand( num2cell( pt.inout( :, end ) ) ), layer.ind ), 2 );

if imag( k( 1 ) ) == 0 && ~isempty( ind1 )
  %  loop over positive propagation directions 
  for i = reshape( find( ind1 ), 1, [] )
    %  parallel wavevector component for stationary phase expansion
    kpar = k( 1 ) * sqrt( 1 - dir( i, 3 ) ^ 2 );
    %  reflection/transmission coefficients
    r = reflection( layer, enei, kpar, pos1 );
    %  distance difference in phase factor
    dist = pos( repmat( ind, [ 4, 1 ] ), 1 : 2 ) *  ...
                      transpose( dir( i, 1 : 2 ) ) + layer.z( 1 ) * dir( i, 3 );
    %  phase factor
    phase = transpose( exp( - 1i * k( 1 ) * dist ) );
    
    %  field names
    names = fieldnames( r );
    %  reshape reflection/transmission coefficients
    for j = 1 : length( names )
      r.( names{ j } ) = reshape( r.( names{ j } ) .* phase, [], 4 );
      %  derivatives
      r.( names{ j } )( :, 2 : 4 ) =  ...
        bsxfun( @minus, r.( names{ j } )( :, 2 : 4 ), r.( names{ j } )( :, 1 ) ) / eta;
    end
    
    %  multiplication function
    fun = @( r, dip ) reshape( bsxfun( @times, squeeze( dip ), r ), [], 1 );
    %  vector potential at infinity
    a( i, 1, : ) = - 1i * k0 * fun( r.p(  :, 1 ), dip(  ind, 1, : ) );
    a( i, 2, : ) = - 1i * k0 * fun( r.p(  :, 1 ), dip(  ind, 2, : ) );
    a( i, 3, : ) = - 1i * k0 * fun( r.hh( :, 1 ), dip(  ind, 3, : ) ) +  ...
                               fun( r.hs( :, 2 ), dip2( ind, 1, : ) ) +  ...
                               fun( r.hs( :, 3 ), dip2( ind, 2, : ) ) +  ...
                               fun( r.hs( :, 4 ), dip2( ind, 3, : ) );
  end
end

if imag( k( end ) ) == 0 && ~isempty( ind2 )
  %  loop over negative propagation directions 
  for i = reshape( find( ind2 ), 1, [] )
    %  parallel wavevector component for stationary phase expansion
    kpar = k( end ) * sqrt( 1 - dir( i, 3 ) ^ 2 );
    %  reflection/transmission coefficients
    r = reflection( layer, enei, kpar, pos2 );
    %  distance difference in phase factor
    dist = pos( repmat( ind, [ 4, 1 ] ), 1 : 2 ) *  ...
                      transpose( dir( i, 1 : 2 ) ) + layer.z( end ) * dir( i, 3 ); 
    %  phase factor
    phase = transpose( exp( - 1i * k( end ) * dist ) );
    
    %  field names
    names = fieldnames( r );
    %  reshape reflection/transmission coefficients
    for j = 1 : length( names )
      r.( names{ j } ) = reshape( r.( names{ j } ) .* phase, [], 4 );
      %  derivatives
      r.( names{ j } )( :, 2 : 4 ) =  ...
        bsxfun( @minus, r.( names{ j } )( :, 2 : 4 ), r.( names{ j } )( :, 1 ) ) / eta;
    end
    
    %  multiplication function
    fun = @( r, dip ) reshape( bsxfun( @times, squeeze( dip ), r ), [], 1 );
    %  vector potential at infinity
    a( i, 1, : ) = - 1i * k0 * fun( r.p(  :, 1 ), dip(  ind, 1, : ) );
    a( i, 2, : ) = - 1i * k0 * fun( r.p(  :, 1 ), dip(  ind, 2, : ) );
    a( i, 3, : ) = - 1i * k0 * fun( r.hh( :, 1 ), dip(  ind, 3, : ) ) +  ...
                               fun( r.hs( :, 2 ), dip2( ind, 1, : ) ) +  ...
                               fun( r.hs( :, 3 ), dip2( ind, 2, : ) ) +  ...
                               fun( r.hs( :, 4 ), dip2( ind, 3, : ) );
  end
end

%  electric field
e = 1i * k0 * a;

%%  direct fields
%  material within which dipoles are embedded
inout = pt.expand( num2cell( pt.inout( :, end ) ) );

%  free dipole fields
field = farfield( obj.dip, spectrumret( spec.pinfty, 'medium', medium( 1 ) ), enei ) +  ...
        farfield( obj.dip, spectrumret( spec.pinfty, 'medium', medium( 2 ) ), enei );
%  free fields in upper and lower medium
field1 = field;  field1.e( :, :, inout ~= medium( 1 ), : ) = 0;
field2 = field;  field2.e( :, :, inout ~= medium( 2 ), : ) = 0;
%  add to reflected/transmitted fields
e( ind1, :, : ) = e( ind1, :, : ) + field1.e( ind1, :, : );
e( ind2, :, : ) = e( ind2, :, : ) + field2.e( ind2, :, : );

%%  final output
%  make electric field transversal
e = e - outer( dir, inner( dir, e ) );

%  allocate magnetic field
h = zeros( size( e ) );
%  expand direction
idir = repmat( reshape( dir, [ size( dir ), 1 ] ), [ 1, 1, size( e, 3 ) ] );
%  magnetic field
h( ind1, :, : ) = k(   1 ) / k0 * cross( idir( ind1, :, : ), e( ind1, :, : ), 2 );
h( ind2, :, : ) = k( end ) / k0 * cross( idir( ind2, :, : ), e( ind2, :, : ), 2 );

try
  %  upper and lower particle
  p1 = select( spec.pinfty, 'index', ind1 );  ind1 = find( ind1 );
  p2 = select( spec.pinfty, 'index', ind2 );  ind2 = find( ind2 );
  %  save to structure
  field = compstruct(  ...
    comparticle( pt.eps, { p1, p2 }, transpose( medium ) ), enei );
catch
  [ ind1, ind2 ] = deal( find( ind1 ), find( ind2 ) );
  %  save to structure
  field = compstruct( spec.pinfty, enei );
end

%  size of output array
siz = [ size( e, 1 ), size( e, 2 ), size( dip, 1 ), size( dip, 3 ) ];
%  rearrange electric fields
field.e = reshape( e( [ ind1; ind2 ], :, : ), [ size( dir, 1 ), siz( 2 : end ) ] );
field.h = reshape( h( [ ind1; ind2 ], :, : ), [ size( dir, 1 ), siz( 2 : end ) ] );

