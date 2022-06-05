function varargout = subsref( obj, s )
%  Access to class functions and properties of MESHFIELD.
%
%  Usage for obj = meshfield :
%    obj.pos     :  point positions
%    obj( sig )  :  compute electromagnetic fields
    
switch s( 1 ).type  
  case '.'  
    switch s( 1 ).subs
      case 'pos'
        varargout{ 1 } = subarray( obj.pt.pos, s );
      otherwise
        [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
    end  
  case '()'  
    [ varargout{ 1 : nargout } ] = field( obj, s( 1 ).subs{ : } );
end
