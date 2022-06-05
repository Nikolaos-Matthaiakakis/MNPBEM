function obj = diag( obj, ind, f )
%  DIAG - Set diagonal elements of surface derivative of Green function.
%
%  Usage for obj = greenstat :
%    obj = diag( obj, ind, f )
%  Input
%    ind    :  index to diagonal elements
%    f      :  value of diagonal element

%  convert indices
ind = sub2ind( obj.p1.n * [ 1, 1 ], ind, ind );  

%  save elements
if isempty( obj.ind )
  %  save indices
  obj.ind = ind;
  %  save Green function and surface derivative
  [ obj.g, obj.f ] = deal( zeros( size( ind ) ), f );
else
  [ ~, i1, i2 ] = intersect( obj.ind, ind );
  obj.f( i1, : ) = obj.f( i1, : ) + f( i2, : );
end
