function obj = flat( obj )
%  FLAT - Make flat particle boundary.
%
%  Usage for obj = particle :
%    obj = flat( obj )

%  set curved flag
obj.interp = 'flat';
%  auxiliary information for discretized particle surface
obj = norm( obj );
