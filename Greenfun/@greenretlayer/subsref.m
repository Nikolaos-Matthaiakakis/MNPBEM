function varargout = subsref( obj, s )
%  Derived properties for objects of class compgreen.
%
%  Usage for obj = greenretlayer :
%    obj = obj( enei )  :  initialize reflected Green functions

switch s( 1 ).type
  case '.'    
    [ varargout{ 1 : nargout } ]  = builtin( 'subsref', obj, s );
  case '()'
    varargout{ 1 } = initrefl( obj, s( 1 ).subs{ : } );
end