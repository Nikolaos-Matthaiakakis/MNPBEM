function [ v1, v2, t1, t2 ] = deriv( obj, v )
%  DERIV - Tangential derivative of function defined on surface.
%
%  Usage for obj = particle :
%    [ v1, v2, vec1, vec2 ] = deriv( obj, v )
%  Input
%    v       :  function values given at vertices 
%  Output
%    v1, v2  :  derivatives along TVEC at boundary centroids
%    t1, t2  :  triangular or quadrilateral directions

%  Example :  Computation of tangential gradient 
%
%  %  normal vector
%  nvec = cross( t1, t2 );
%  %  decompose into norm and unit vector
%  h = sqrt( dot( nvec, nvec, 2 ) );  nvec = bsxfun( @rdivide, nvec, h );
% 
%  %  tangential gradient of V
%  grad = outer( bsxfun( @rdivide, cross( t2, nvec, 2 ), h ), v1 ) -  ...
%         outer( bsxfun( @rdivide, cross( t1, nvec, 2 ), h ), v2 );

%  array size and reshaped array
[ siz, v ] = deal( size( v ), reshape( v, size( v, 1 ), [] ) );
%  index to triangles and vertices
[ ind3, ind4 ] = index34( obj );

%%  function derivative
%  derivatives of V wrt triangular coordinates
if ~isempty( ind3 )
  %  triangular shape function
  s = shape.tri( 3 );
  %  apply derivative of shape function
  v1( ind3, : ) = apply( s.y( 1/3, 1/3 ), obj.faces( ind3, 1 : 3 ), v );
  v2( ind3, : ) = apply( s.x( 1/3, 1/3 ), obj.faces( ind3, 1 : 3 ), v );
end
%  derivatives of V wrt quadrilateral coordinates
if ~isempty( ind4 )
  %  triangular shape function
  s = shape.quad( 4 );
  %  apply derivative of shape function
  v1( ind4, : ) = apply( s.y( 0, 0 ), obj.faces( ind4, 1 : 4 ), v );
  v2( ind4, : ) = apply( s.x( 0, 0 ), obj.faces( ind4, 1 : 4 ), v );
end

%%  tangential vectors
%  derivative of position wrt boundary coordinates
switch obj.interp
  %  flat boundary elements
  case 'flat'
    %  derivatives of boundary position wrt triangular coordinates
    if ~isempty( ind3 )
      %  triangular shape function
      s = shape.tri( 3 );      
      %  apply derivative of shape function
      t1( ind3, : ) = apply( s.y( 1/3, 1/3 ), obj.faces( ind3, 1 : 3 ), obj.verts );
      t2( ind3, : ) = apply( s.x( 1/3, 1/3 ), obj.faces( ind3, 1 : 3 ), obj.verts );
    end
    %  derivatives of boundary position wrt quadrilateral coordinates
    if ~isempty( ind4 )
      %  quadrilateral shape function
      s = shape.quad( 4 );      
      %  apply derivative of shape function
      t1( ind4, : ) = apply( s.y( 0, 0 ), obj.faces( ind4, 1 : 4 ), obj.verts );
      t2( ind4, : ) = apply( s.x( 0, 0 ), obj.faces( ind4, 1 : 4 ), obj.verts );
    end   
    
  %  curved boundary elements
  case 'curv'
    %  derivatives of boundary position wrt triangular coordinates
    if ~isempty( ind3 )
      %  triangular shape function and index to faces
      [ s, ind ] = deal( shape.tri( 6 ), [ 1, 2, 3, 5, 6, 7 ] );
      %  apply derivative of shape function
      t1( ind3, : ) = apply( s.y( 1/3, 1/3 ), obj.faces2( ind3, ind ), obj.verts2 );
      t2( ind3, : ) = apply( s.x( 1/3, 1/3 ), obj.faces2( ind3, ind ), obj.verts2 );
    end
    %  derivatives of boundary position wrt quadrilateral coordinates
    if ~isempty( ind4 )
      %  quadrilateral shape function
      s = shape.quad( 9 );      
      %  apply derivative of shape function
      t1( ind4, : ) = apply( s.y( 0, 0 ), obj.faces2( ind4, 1 : 9 ), obj.verts2 );
      t2( ind4, : ) = apply( s.x( 0, 0 ), obj.faces2( ind4, 1 : 9 ), obj.verts2 ); 
    end
end

%  size of output array
siz( 1 ) = size( v1, 1 );
%  reshape output arrays
[ v1, v2 ] = deal( reshape( v1, siz ), reshape( v2, siz ) );


function vout = apply( s, faces, vin )
%  APPLY - Apply shape function to value array.

%  output array
vout = zeros( size( faces, 1 ), size( vin, 2 ) );
%  loop over shape elements
for i = 1 : size( s, 2 );
  vout = vout + s( i ) * vin( faces( :, i ), : );
end
