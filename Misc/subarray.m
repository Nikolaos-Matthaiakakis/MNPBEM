function varargout = subarray( a, s )
%  SUBARRAY - Pass arguments to subsref.

if length( s ) > 1
  [ varargout{ 1 : nargout } ] = subsref( a, s( 2 : end ) ); 
else
  varargout{ 1 } = a;
end