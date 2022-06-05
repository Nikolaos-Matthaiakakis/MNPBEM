function [ x, y, w ] = trisubdivide( xtab, ytab, wtab, nsub )
%  TRISUBDIVIDE - Refines triangle integration of unit triangle.
%
%  Input
%    xtab   :  x coordinates of integration points
%    ytab   :  y coordinates of integration points
%    wtab   :  weights of integration points
%    nsub   :  triangle is divided nsub times
%
%  Output
%    x, y   :  refined coordinates
%    w      :  refined weights

x = [];
y = [];
w = [];

h = 1 / nsub;

for i = 0 : nsub - 1
for j = 0 : nsub - 1 - i

  %  triangle pointing upwards
  x = [ x, i + xtab ];
  y = [ y, j + ytab ];
  w = [ w, wtab ];
  
  %  triangle pointing downwards
  if ( j ~= nsub - 1 - i )
    x = [ x, i + 1 - xtab ];
    y = [ y, j + 1 - ytab ];
    w = [ w, wtab ];
  end
    
end
end

x = x * h;
y = y * h;
w = w / ( numel( x ) / numel( xtab ) );
