function varargout = subsref( obj, s )
%  Derived properties for objects of class compgreenmirror.
%
%  Usage for obj = compgreenretmirror :
%    obj{ i, j }.G( enei )  :  composite Green function
%    obj.field( sig )       :  call     field 
%    obj.potential( sig )   :  call potential 

switch s( 1 ).type
  case '.'
    switch s( 1 ).subs
      case 'con'
        varargout{ 1 } = subsref( obj.g, s );
      otherwise
        [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );
    end
  otherwise
    varargout{ 1 } = eval( obj, s );
end
