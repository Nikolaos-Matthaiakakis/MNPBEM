function is = isbase( obj, p )
%  ISBASE - Checks for equality of particle objects.
%
%  Usage for obj = valarray :
%    is = isbase( obj, p )
%  Input
%    p      :  discretized particle object
%  Output
%    is     :  true if particle of OBJ is same as P, and false otherwise

if ~isnumeric( p ) && size( p.verts, 1 ) == size( obj.p.verts, 1 ) &&  ...
                             all( p.verts( : ) == obj.p.verts( : ) )
  is = true;
else
  is = false;
end
  