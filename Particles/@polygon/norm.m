function nvec = norm( obj )
%  Normal vector at polygon positions.
%
%  Usage for obj = polygon :
%    nvec = norm( obj )
%  Output
%    nvec   :  normal vectors

pos = obj.pos;
%  unit vector
unit = @( v ) bsxfun( @rdivide, v, sqrt( dot( v, v, 2 ) ) );

%  normal vectors
vec = pos( [ 2 : end, 1 ], : ) - pos( 1 : end, : );

nvec = [ - vec( :, 2 ), vec( :, 1 ) ];
nvec = unit( nvec );

%  intgerpolate to polygon positions
nvec = ( nvec + circshift( nvec, [ 1, 0 ] ) ) / 2;
nvec = unit( nvec );

%  check direction of normal vectors
posp = pos + 1e-6 * nvec;

in = inpolygon( posp( :, 1 ), posp( :, 2 ), pos( :, 1 ), pos( :, 2 ) );

switch obj.dir
  case 1
    nvec(  in, : ) = - nvec(  in, : );
  case - 1
    nvec( ~in, : ) = - nvec( ~in, : );
end

%  normal vector at symmetry points
if ~isempty( obj.sym )
  if any( strcmp( obj.sym, { 'x', 'xy' } ) )
    nvec( abs( pos( :, 1 ) ) < 1e-10, 1 ) = 0;
  end
  if any( strcmp( obj.sym, { 'y', 'xy' } ) )
    nvec( abs( pos( :, 2 ) ) < 1e-10, 2 ) = 0;      
  end
  nvec = unit( nvec );
end
