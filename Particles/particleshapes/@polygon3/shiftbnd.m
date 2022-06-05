function obj = shiftbnd( obj, dist )
%  SHIFTBND - Shift boundary of polygon along normal directions.
%
%  Usage for obj = polygon3 :
%    obj = shiftbnd( obj, dist )
%  Input
%    obj    :  single object or array
%    dist   :  shift polygon vertices along normal directions by dist
%  Output
%    obj    :  shifted polygon

for i = 1 : numel( obj )
  obj( i ).poly = shiftbnd( obj( i ).poly, dist );
  %  clear EDGE profile
  obj( i ).edge = edgeprofile;
end
