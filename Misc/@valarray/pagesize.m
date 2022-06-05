function siz = pagesize( obj, val )
%  PAGESIZE - Paging size of VALARRAY object or user-defined value array.
%
%  Usage for obj = valarray :
%    siz = pagesize( obj )
%    siz = pagesize( obj, val )
%  Input
%    val  :  value array

if ~exist( 'val', 'var' ),  val = obj.val;  end
%  size of value array
siz = size( val );  
siz = siz( 2 : end );
