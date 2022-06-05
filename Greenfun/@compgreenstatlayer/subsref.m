function varargout = subsref( obj, s )
%  Derived properties for objects of class compgreenstatlayer.
%
%  Usage for obj = compgreenstatlayer :
%    obj.G( enei )          :  Green function for given wavelength
%    obj.field( sig )       :  fields at particle boundary
%    obj.potential( sig )   :  potential at particle boundary

switch s( 1 ).type
    
  %  quasistatic Green function    
  case '.'  

    switch s( 1 ).subs
      case { 'G', 'F', 'H1', 'H2', 'Gp' }
        varargout{ 1 } = eval( obj, s( 2 ).subs{ : }, s( 1 ).subs );
      case 'field'
        varargout{ 1 } = field(     obj, s( 2 ).subs{ : } );
      case 'potential'
        varargout{ 1 } = potential( obj, s( 2 ).subs{ : } );        
      otherwise
        [ varargout{ 1 : nargout } ]  = builtin( 'subsref', obj, s );
    end
end
