function stat = stat( obj )
%  STAT - Pointer to statistics.
%
%  Usage for obj = hmatrix :
%    s = stat( obj )
%  Output
%    stat 	:  structure for saving statistics

%  save statistics ?
sav = 1;

switch sav
  case 0
    stat = {};
  case 1
    stat = { obj.stat };
end
