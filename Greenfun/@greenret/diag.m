function obj = diag( obj, ind, f )
%  DIAG - Set diagonal elements of surface derivative of Green function.
%
%  Usage for obj = greenret :
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
  %  save Green function and surafce derivative
  [ obj.g, obj.f ] = deal( zeros( size( ind ) ), f );
else
  %  loop over indices
  for i = 1 : length( ind )
    if numel( size( obj.f ) ) == 2
      obj.f( obj.ind == ind( i ), 1 ) =  ...
      obj.f( obj.ind == ind( i ), 1 ) + f( i );      
    else
      obj.f( obj.ind == ind( i ), :, 1 ) =  ...
      obj.f( obj.ind == ind( i ), :, 1 ) + reshape( f( i, : ), [ 1, 3, 1 ] );
    end
  end
end
