function obj = initrefl3( obj, enei, ind )
%  INITREFL3 - Initialize reflected part of Green function for given indices.
%    We compute G and the surface derivative F.
%
%  Usage for obj = greenretlayer :
%    obj = initrefl( obj, enei, ind )
%  Input
%    enei   :  wavelength of light in vacuum
%    ind    :  index to matrix elements to be computed

%  tabulated Green functions
obj.tab = eval( obj.tab, enei );  tab = obj.tab;

%  rows and columns of elements to be computed
[ row, col ] = ind2sub( [ obj.p1.n, obj.p2.n ], ind );
%  particles or point positions
[ pos1, pos2 ] = deal( obj.p1.pos, obj.p2.pos );
%  difference vectors
x = pos1( row, 1 ) - pos2( col, 1 );
y = pos1( row, 2 ) - pos2( col, 2 );
%  radii
r = sqrt( x .^ 2 + y .^ 2 );
%  positions in z-direction
z1 = pos1( row, 3 );
z2 = pos2( col, 3 );

%  normal vector and area
nvec = obj.p1.nvec( row, : );
area = obj.p2.area( col );
%  inner product
in = ( x .* nvec( :, 1 ) + y .* nvec( :, 2 ) ) ./ max( r, 1e-10 );       
%  perform interpolation
[ G, Fr, Fz ] = interp( tab, r, z1, z2 );

%  get field names
names = fieldnames( G );
%  multiply with area and compose surface derivative of Green function
for i = 1 : length( names )
  G.( names{ i } ) = G.( names{ i } ) .* area;
  %  surface derivative of Green function
  F.( names{ i } ) =  ( Fr.( names{ i } ) .* in +  ...
                        Fz.( names{ i } ) .* nvec( :, 3 ) ) .* area;
end

%%  refine diagonal elements 
if ~isempty( obj.id ) && ~isempty( intersect( obj.id, ind ) )
  %  Green function elements with refinement
  [ ~, ind1, ind2 ] = intersect( obj.id, ind );  
  %  particle and index to diagonal elements
  [ p, id2 ] = deal( obj.p1, obj.id( ind1 ) );
  %  row index
  [ id, ~ ] = ind2sub( p.n * [ 1, 1 ], id2 );
  
  %  integration points and weights for polar integration
  [ pos1, weight, row ] = quadpol( p, id );
  %  centroids (expand to size of integration points)
  pos2 = p.pos( id( row ), : );
  
  %  difference vectors
  x = pos1( :, 1 ) - pos2( :, 1 );
  y = pos1( :, 2 ) - pos2( :, 2 );
  %  radial distance between points
  r = sqrt( x .^ 2 + y .^ 2 );
  %  positions in z-direction
  z1 = pos1( :, 3 );
  z2 = pos2( :, 3 );  
  
  %  normal vector
  nvec = obj.p1.nvec( id( row ), : );
  %  inner product
  in = ( bsxfun( @times, x, nvec( :, 1 ) ) +  ...
         bsxfun( @times, y, nvec( :, 2 ) ) ) ./ max( r, 1e-10 );   
 
  %  perform interpolation
  [ g, fr, fz, r, z ] = interp( obj.tab, r, z1, z2 );
  %  distance
  rr = sqrt( r .^ 2 + z .^ 2 );
  
  % %  refine diagonal elements (w/o explicit consideration of divergent term)
  % for i = 1 : length( names )
  %   G.( names{ i } )( ind2 ) = accumarray( row, weight .* g.(  names{ i } ) );
  %   F.( names{ i } )( ind2 ) = accumarray( row, weight .*  ...
  %     ( fr.( names{ i } ) .* in + bsxfun( @times, fz.( names{ i } ), nvec( :, 3 ) ) ) );
  % end  
  
  %  index to positions located inside layer
  [ ~, lin ] = indlayer( obj.layer, p.pos( id, 3 ) );
  %  expand to size of integration points
  linrow = lin( row );
  %  matrix index
  lin2 = ind2( lin ); 
  
  %  layer index and layer position
  [ ~, ind ] = mindist( obj.layer, p.pos( id( lin ), 3 ) );
  z0 = obj.layer.z( ind );
  %  direction from layer to particle boundary
  dir = sign( p.pos( id( lin ), 3 ) - obj.layer.z( ind ) );
  %  element with r -> 0, z -> 0
  if any( lin )
    [ ~, ~, f0, r0, z0 ] =  ...
      interp( obj.tab, 0 * z0, z0 + 1e-10 * dir, z0 + 1e-10 * dir );
  end
  
  %  f0 is given at particle centroids of boundary elements in the layer, 
  %    IROW expands the centroid index to the integration points
  [ irow, ~, n ] = unique( row( any( bsxfun( @eq, row, find( lin )' ), 2 ) ) );
  %  replace elements ( i1, i1, i2, ... ) with ( 1, 1, 2, ... )
  irow = subsref( 1 : numel( irow ), substruct( '()', { n } ) );

  %  refine diagonal elements
  for i = 1 : length( names )
    %  integrate Green function
    G.( names{ i } )( ind2 ) = accumarray( row, weight .* g.( names{ i } ) );

    %  surface derivative of Green function
    fzi = fz.( names{ i } );        
    %  element with r -> 0, z -> 0
    %    Waxenegger et al., Comp. Phys. Commun. 193, 138 (2015), Eq. (17).
    if any( lin )
      f = f0.( names{ i } ) .* ( r0 .^ 2 + z0 .^ 2 ) .^ 1.5 ./ z0;    
      %  subtract divergent part for boundary elements in layer
      fzi( linrow ) = fzi( linrow ) - f( irow ) .* z( linrow ) ./ rr( linrow ) .^ 3;
      %  reshape z-derivative of Green function
      fzi = reshape( fzi, size( fz.( names{ i } ) ) );
    else
      f = 0;
    end
    
    %  integrate surface derivative of Green function w/o divergent term
    F.( names{ i } )( ind2 ) = accumarray( row, weight .*  ...
      ( fr.( names{ i } ) .* in + bsxfun( @times, fzi, nvec( :, 3 ) ) ) );
    %  add divergent term
    F.( names{ i } )( lin2 ) =  ...
    F.( names{ i } )( lin2 ) + 2 * pi * f .* obj.p1.nvec( id( lin ), 3 );
  end
end

%%  refine off-diagonal elements
if isempty( obj.ind ) && ~isempty( obj.ir )
  %  Green function elements with refinement
  [ ~, ind1, ind2 ] = intersect( obj.ind, ind );    
  %  refinement with Green function interpolation in boundary elements
  [ g, fr, fz ] = interp( obj.tab, obj.ir( ind1 ), obj.iz( ind1, 1 ), obj.iz( ind1, 2 ) );
  %  refine elements
  for i = 1 : length( names )
    G.( names{ i } )( ind2 ) = obj.ig(  ind1, : ) * g.(  names{ i } );
    F.( names{ i } )( ind2 ) = obj.ifr( ind1, : ) * fr.( names{ i } ) + ...
                               obj.ifz( ind1, : ) * fz.( names{ i } );
  end
end

%%  save reflected part of Green function
[ obj.G, obj.F ] = deal( G, F );
