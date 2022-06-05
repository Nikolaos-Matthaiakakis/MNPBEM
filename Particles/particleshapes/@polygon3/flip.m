function obj = flip( obj, ax )
%  FLIP - Flip polygon along given axis.
%
%  Usage for obj = polygon :
%    obj = flip( obj, ax )
%  Input
%    dir    :  x- (ax = 1) or y-axis (ax = 2) along which polygon is flipped
%  Output
%    obj    :  flipped polygon

obj.poly = flip( obj.poly, ax );
