function varargout = unpack( obj, vec )
%  UNPACK - Unpack scalar and vector potentials from vector.

%  last dimension
siz = numel( vec ) / ( 8 * obj.p.n );
%  reshape vector
vec = reshape( vec, [], 8 );
%  extract potentials from vector
phi  = reshape( vec( :, 1     ), [],    siz );
a    = reshape( vec( :, 2 : 4 ), [], 3, siz );
phip = reshape( vec( :, 5     ), [],    siz );
ap   = reshape( vec( :, 6 : 8 ), [], 3, siz );

if nargout == 4
  [ varargout{ 1 : 4 } ] = deal( phi, a, phip, ap );
else
  %  decompose vectors into parallel and perpendicular components
  [ apar,  aperp  ] = deal( a(  :, 1 : 2, : ), squeeze( a(  :, 3, : ) ) );
  [ appar, apperp ] = deal( ap( :, 1 : 2, : ), squeeze( ap( :, 3, : ) ) );
  %  assign output
  [ varargout{ 1 : 6 } ] = deal( phi, apar, aperp, phip, appar, apperp );
end
