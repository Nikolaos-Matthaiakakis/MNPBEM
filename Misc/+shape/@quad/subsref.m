function val = subsref( obj, s )
%  Derived properties for objects of class QUAD.
%
%  Usage for obj = quad :
%    obj(   x, y )  :  evaluate quadrilateral shape functions
%    obj.x( x, y )  :  derivative of quadrilateral shape functions
%                        works for 'x', 'y', 'xx', 'yy', 'xy'

switch s( 1 ).type
  case '.'
    switch s( 1 ).subs
      case { 'x', 'y', 'xx', 'yy', 'xy' }
        val = deriv( obj, s( 2 ).subs{ : }, s( 1 ).subs );  
      case 'apply'
        val = apply( obj, s( 2 ).subs{ : } );         
      otherwise
        val = builtin( 'subsref', obj, s );  
    end
  case '()'
    val = eval( obj, s( 1 ).subs{ : } );
end
