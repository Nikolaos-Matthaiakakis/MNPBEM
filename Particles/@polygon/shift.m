function obj = shift( obj, vec )
%  SHIFT - Shift polygon by given vector.
%
%  Usage for obj = polygon :
%    obj = shift( obj, vec )
%  Input
%    vec    :  translation vector

for i = 1 : numel( obj )
  obj( i ).pos = bsxfun( @plus, obj( i ).pos, vec );
end
