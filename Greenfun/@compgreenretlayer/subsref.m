function varargout = subsref( obj, s )
%  Derived properties for objects of class COMPGREENRETLAYER.
%
%  Usage for obj = compgreenretlayer :
%    obj{ i, j }.G( enei )  :  composite Green function 
%    obj( enei )            :  initialize reflected part of Green function
%    obj.field( sig )       :  compute electric and magnetic fields
%    obj.potential( sig )   :  compute potentials
%    obj.deriv              :  'cart' or 'norm'
%
%    works for { G, Gp, F, H1, H2 }

switch s( 1 ).type
  case '.'    
    switch s( 1 ).subs
      case 'field'
        varargout{ 1 } = field(     obj, s( 2 ).subs{ : } );
      case 'potential'
        varargout{ 1 } = potential( obj, s( 2 ).subs{ : } );        
      case 'deriv'
        varargout{ 1 } = obj.gr.deriv;
      otherwise
        [ varargout{ 1 : nargout } ]  = builtin( 'subsref', obj, s );
    end
  case '()'
    %  initialize reflected part of Green function
    varargout{ 1 } = initrefl( obj, s( 1 ).subs{ : } );
  case '{}'
    %  Green function and or surface derivative of Green function  
    varargout{ 1 } =  ...
      eval( obj, s( 1 ).subs{ : }, s( 2 ).subs, s( 3 ).subs{ : } );
end