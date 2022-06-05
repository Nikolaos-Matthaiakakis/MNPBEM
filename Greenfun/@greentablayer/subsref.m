function varargout = subsref( obj, s )
%  Access to class functions and properties of tabulated Green function.
%
%  Usage for obj = greentablayer :
%    obj.size               :  size of tabulated grid
%    obj.numel              :  number of elements of tabulated grid
%    obj.inside( r, z )     :  call inside function
%    obj( r, z )            :  perform interpolation
    
switch s( 1 ).type  
  %  functions and class variables  
  case '.'  
    switch s( 1 ).subs
      case 'numel'
        varargout{ 1 } = get( obj, 'numel' );      
      case 'size'
        varargout{ 1 } = subarray( get( obj, 'size' ), s );
      case 'inside'
        varargout{ 1 } = inside( obj, s( 2 ).subs{ : } );        
      otherwise
        [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
    end  
  case '()'
    [ varargout{ 1 : nargout } ] = interp( obj, s( 1 ).subs{ : } );
end


function n = get( obj, key )
%  GET - Get size or number of elements of Green function object.

switch key
  case 'numel'
    n = numel( obj.r ) * numel( obj.z1 ) * numel( obj.z2 );
  case 'size'
    n = [ numel( obj.r ), numel( obj.z1 ), numel( obj.z2 ) ];
    %  remove ones
    n = n( n ~= 1 );
end
