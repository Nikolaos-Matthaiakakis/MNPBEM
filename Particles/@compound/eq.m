function eq = eq( obj1, obj2 )
%  Test for equality between two objects (compare positions).
%
%  Usage for obj = compound :
%    obj1 == obj2

eq = ( length( obj1.pc.pos( : ) ) == length( obj2.pc.pos( : ) ) ) &&  ...
                    all( obj1.pc.pos( : ) == obj2.pc.pos( : ) );
  