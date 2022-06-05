function obj = truncate( obj, htol )
%  TRUNCATE - Truncate hierarchical matrix.
%
%  Usage for obj = hmatrix :
%    obj = truncate( obj )
%    obj = truncate( obj, htol )
%  Input
%    htol   :  tolerance for truncation of low-rank matrices
%
%  See S. Böhm et al., Eng. Analysis with Bound. Elem. 27, 405 (2003),
%    truncation described in Sec. 3.3.

if ~exist( 'htol', 'var' ),  htol = obj.htol;  end

[ obj.lhs, obj.rhs ] = cellfun(  ...
  @( lhs, rhs ) fun( lhs, rhs, htol ), obj.lhs, obj.rhs, 'uniform', 0 );
%  set tolerance
obj.htol = htol;


function [ lhs, rhs ] = fun( lhs, rhs, htol )
%  FUN - Truncate low-rank matrix.

%  deal with zero matrices
if norm( lhs( : ) ) < eps || norm( rhs( : ) ) < eps,  return;  end

[ q1, r1 ] = qr( lhs, 0 );
[ q2, r2 ] = qr( rhs, 0 );
%  SVD decomposition 
[ u, s, v ] = svd( r1 * transpose( r2 ) );  s = diag( s );
% find largest singular values
k = find( cumsum( s ) < ( 1 - htol ) * sum( s ) );
%  truncate low-rank matrics
lhs = q1( :, k ) * u( k, k ) * diag( s( k ) );
rhs = q2( :, k ) * conj( v( k, k ) );
