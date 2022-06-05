function obj = close( obj )
%  CLOSE - Close polygon in case of xy-symmetry.
%    Add origin (0,0) to polygon list (unless it is already part of the list)
%
%  Usage for obj = polygon :
%    obj = close( obj )
%  Input/output
%    obj    :  single object or array

if length( obj ) ~= 1
  for i = 1 : length( obj )
    obj( i ) = close( obj( i ) );
  end
  return
end

if isempty( obj.sym ) || ~strcmp( obj.sym, 'xy' );  return;  end

%  add origin to position list ?
obj = sort( obj );
pos = obj.pos;

if ~all(  abs( pos( end, : ) )   < 1e-6 ) &&  ...
    abs( prod( pos( 1,   : ) ) ) < 1e-6   &&   ...
    abs( prod( pos( end, : ) ) ) < 1e-6 
  obj.pos = [ pos; 0, 0 ];
end
