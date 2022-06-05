function ne = ne( obj1, obj2 )
%  Test for inequality between two objects (compare positions).
%
%  Usage for obj = compound :
%    obj1 ~= obj2

ne = ~eq( obj1, obj2 );
