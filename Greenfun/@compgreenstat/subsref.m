function varargout = subsref( obj, s )
%  Derived properties for objects of class compgreenstat.
%
%  Usage for obj = compgreenstat :
%    obj.G                  :  Green function for given wavevector k
%    obj.field( sig )       :  fields at particle boundary
%    obj.potential( sig )   :  potential at particle boundary
%    obj.deriv              :  'cart' or 'norm'
%
%    works for { G, F, H1, H2, Gp } (see greenstat)

switch s( 1 ).type
  case '.'  
    switch s( 1 ).subs
      case { 'G', 'F', 'H1', 'H2', 'Gp' }
        varargout{ 1 } = eval( obj.g, s.subs );
      case 'field'
        varargout{ 1 } = field(     obj, s( 2 ).subs{ : } );
      case 'potential'
        varargout{ 1 } = potential( obj, s( 2 ).subs{ : } );         
      otherwise
        [ varargout{ 1 : nargout } ]  = builtin( 'subsref', obj, s );
    end
end
