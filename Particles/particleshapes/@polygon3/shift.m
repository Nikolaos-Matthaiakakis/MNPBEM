function obj = shift( obj, vec )
%  SHIFT - Shift polygon by given vector.
%
%  Usage for obj = polygon2 :
%    obj = shift( obj, vec )
%  Input
%    vec    :  translation vector

%  shift polygon
obj.poly = shift( obj.poly, vec( 1 : 2 ) );
%  shift z-value
obj.z = obj.z + vec( 3 );
