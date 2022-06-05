function varargout = subsref( obj, s )
%  Derived properties for objects of class COMPGREENSTATMIRROR.
%
%  Usage for obj = compgreenstatmirror :
%    obj.G                  :  Green function 
%    obj.field( sig )       :  call     field 
%    obj.potential( sig )   :  call potential 

switch s( 1 ).subs
  case 'con'
    varargout{ 1 } = subsref( obj.g, s );
  case { 'G', 'F', 'H1', 'H2', 'Gp', 'H1p', 'H2p' }
    varargout{ 1 } = eval( obj, s );
  otherwise
    [ varargout{ 1 : nargout } ] = builtin( 'subsref', obj, s );    
end
