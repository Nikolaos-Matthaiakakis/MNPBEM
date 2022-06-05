function varargout = subsref( obj, s )
%  Class properties and derived properties for DIPOLERETMIRROR objects.
%
%  Usage for obj = dipoleretmirror :
%    obj( p, enei )         :  external potential 
%    obj.field( p, enei )   :  electric field
%    obj.full( val )        :  expand COMPSTRUCTMIRROR object for full particle
%    obj.decayrate( sig )   :  total and radiative decay rate

switch s( 1 ).type
  case '.'  
    switch s( 1 ).subs
      case 'field'
        varargout{ 1 } = field( obj, s( 2 ).subs{ : } );
      case 'decayrate'
        [ varargout{ 1 : nargout } ] = decayrate( obj, s( 2 ).subs{ : } );
      case 'full'
        varargout{ 1 } = full( obj, s( 2 ).subs{ : } );        
      otherwise
        varargout{ 1 } = builtin( 'subsref', obj, s );
    end
  case '()'
    varargout{ 1 } = potential( obj, s( 1 ).subs{ : } );
end
