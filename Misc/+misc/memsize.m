function m = memsize
%  MEMSIZE - Memory size used for working successively through large arrays.
%
%  Usage :
%    m = memsize
%  Output
%    m    :  memory size
%
%  When workin successively through large arrays, we split the array into
%  portions of maximal size M to avoid out of memory problems.  The value
%  of M is an approximate value which does not guarantee out of memory
%  problems.  In case of limited or more exhaustive available memorier one
%  might consider decreaasing or increasing this value, or to pass a
%  different memory size in the options array.

m = 5000 * 5000;