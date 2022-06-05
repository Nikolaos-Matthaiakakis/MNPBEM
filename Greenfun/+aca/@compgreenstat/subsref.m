function varargout = subsref( obj, s )
%  Derived properties for objects of class compgreenstat.
%
%  Usage for obj = aca.compgreenstat :
%    obj.G                  :  Green function for given wavevector k
%    obj.field( sig )       :  fields at particle boundary
%    obj.potential( sig )   :  potential at particle boundary
%
%    works for { G, F, H1, H2 } 

switch s( 1 ).type
  case '.'  
    switch s( 1 ).subs
      case { 'G', 'F', 'H1', 'H2' }
        varargout{ 1 } = eval( obj, s.subs );
      case 'potential'
        varargout{ 1 } = potential( obj, s( 2 ).subs{ : } ); 
      otherwise
        [ varargout{ 1 : nargout } ]  = builtin( 'subsref', obj, s );
    end
end
