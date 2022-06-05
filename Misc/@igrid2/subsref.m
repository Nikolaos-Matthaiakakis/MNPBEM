function varargout = subsref( obj, s )
%  Access to class functions and properties of igrid2.
%
%  Usage for obj = igrid2 :
%    obj.size               :  size of grid used for interpolation
%    obj.numel              :  number of grid elements
%    obj.finterp( x, y )    :  interpolation function
%    obj( x, y, v )         :  perform interpolation for array V
    
switch s( 1 ).type  
  %  functions and class variables  
  case '.'  
    switch s( 1 ).subs
      case 'size'
        varargout{ 1 } = subarray( [ numel( obj.x ), numel( obj.y ) ], s );
      case 'numel'
        varargout{ 1 } = numel( obj.x ) * numel( obj.y );
      case 'finterp'
        varargout{ 1 } = finterp( obj, s( 2 ).subs{ : } );
      otherwise
        [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
    end  
  %  perform interpolation 
  case '()'  
    varargout{ 1 } =  ...
      feval( finterp( obj, s( 1 ).subs{ 1 : 2 } ), s( 1 ).subs{ 3 } );
end
