function d = pdist2( p1, p2 )
%  PDIST2 - Distance array between positions P1 and P2.
%
%  Usage :
%    d = pdist2( p1, p2 )
%  Input
%    p1     :  positiaon array
%    p2     :  position array
%  Output
%    d      :  distance array between P1 and P2

%  square of distance
d = bsxfun( @plus, dot( p1, p1, 2 ), dot( p2, p2, 2 )' ) - 2 * p1 * p2';
%  avoid rounding errors
d( d < 1e-10 ) = 0;
%  square root of distance
d = sqrt( d );
