function x = uintmex( x )
%  UINTMEX - Convert unsigned integer array to format for MEX calls.

switch mexext
  case { 'mexw64', 'mexa64', 'mexmaci64' }
     x = uint64( x );
  case { 'mexw32', 'mexglx', 'mexmac', 'mexmaci' }
    x = uint32( x );
  otherwise
    error( 'unknown computer architecture' );
end
